import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/chat_model.dart';
import 'package:instagram_clone/services/notification.dart';

class ChatProvider extends ChangeNotifier {
  final _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final Map<String, List<ChatModel>> chats = {};

  Future getMessages(String chatId) async {
    _dbRef.child("chats/$chatId/messages").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        chats[chatId] = data.entries.map((entry) =>
            ChatModel.fromMap(Map<String, dynamic>.from(entry.value))).toList()
          ..sort((a, b) => b.timeSent.compareTo(a.timeSent));
        notifyListeners();
      }
    });
  }

  Future<List<ChatModel>> getUserChats(String userId) async {
    final response = await _dbRef.child("chats").once();
    final data = response.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) return [];

    Map<String, ChatModel> lastMessages = {};

    data.forEach((chatId, chatData) {
      final messages = chatData["messages"] as Map<dynamic, dynamic>;

      for (var entry in messages.entries) {
        final msgData = Map<String, dynamic>.from(entry.value);
        final ChatModel message = ChatModel.fromMap(msgData, msgId: entry.key);

        if (message.senderId == userId || message.receiverId == userId) {
          if (!lastMessages.containsKey(chatId) || message.timeSent.isAfter(lastMessages[chatId]!.timeSent)) {
            lastMessages[chatId] = message;
          }
        }
      }
    });

    // Convert to list and sort by most recent timeSent
    return lastMessages.values.toList()
      ..sort((a, b) => b.timeSent.compareTo(a.timeSent));
  }

  Future sendMessage(ChatModel message) async {
    final msg = _dbRef.child("chats/${message.chatId}/messages").push();
    await msg.set(message.toMap());
    await msg.update({"messageId": msg.key});


    // Fetch recipient's FCM token from Firestore
    DocumentSnapshot userDoc =
    await _store.collection("users").doc(message.receiverId).get();
    String? fcmToken = userDoc.exists ? userDoc["fcmToken"] : null;

    if (fcmToken != null) {
      // Send push notification using NotificationService
      NotificationService.instance.sendPushNotification(
        fcmToken: fcmToken,
        senderId: message.senderId,
        message: message.message,
      );
    }
  }

  Future deleteMessage(String chatId, String msgId) async {
    await _dbRef.child("chats/$chatId/messages/$msgId").remove();
    chats[chatId]?.removeWhere((msg) => msg.messageId == msgId);
    notifyListeners();
  }
}
