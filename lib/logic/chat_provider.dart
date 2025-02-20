import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("chats").child("path");
  final List<ChatModel> _messages = [];
  List<ChatModel> get messages => _messages;

  ChatProvider() {
    _loadMessages();
  }

  void _loadMessages() {
    _dbRef.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      _messages.add(ChatModel.fromMap(Map<String, dynamic>.from(data)));
      notifyListeners();
    });
  }

  void sendMessage(String message) {
    final newMessage = ChatModel(
      id: DateTime.now().toString(),
      message: message,
      isMe: true,
      timestamp: DateTime.now(),
    );
    _dbRef.push().set(newMessage.toMap());
  }
  //
  // List<ChatModel> getMessages() {
  //   return List.from(_messages);
  // }
}