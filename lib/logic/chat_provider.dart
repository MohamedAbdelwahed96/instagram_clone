import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final _dbRef = FirebaseDatabase.instance.ref();
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

  Future sendMessage(ChatModel message) async {
    final msg = _dbRef.child("chats/${message.chatId}/messages").push();
    await msg.set(message.toMap());
    await msg.update({"messageId": msg.key});
  }

  Future deleteMessage(String chatId, String msgId) async {
    await _dbRef.child("chats/$chatId/messages/$msgId").remove();
    chats[chatId]?.removeWhere((msg) => msg.messageId == msgId);
    notifyListeners();
  }
}
