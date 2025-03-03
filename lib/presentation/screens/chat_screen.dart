import 'package:flutter/material.dart';
import 'package:instagram_clone/core/controllers.dart';
import 'package:instagram_clone/data/chat_model.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/chat_provider.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/profile_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/confirm_message.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final UserModel? user;
  const ChatScreen({super.key, required this.chatId, required this.currentUserId, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final formControllers = FormControllers();
  String? userImg;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Provider.of<ChatProvider>(context, listen: false).getMessages(widget.chatId);
    String? profilePicture = await Provider.of<MediaProvider>(context, listen: false)
        .getImage(bucketName: "images", folderName: "uploads", fileName: widget.user!.pfpUrl);
    setState(() => userImg = profilePicture);
  }

  @override
  void dispose() {
    formControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Consumer<ChatProvider>(builder: (context, provider, _){
      if(userImg==null){
        return CircularProgressIndicator();
      }
      final messages = provider.chats[widget.chatId] ?? [];

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                    CircleAvatar(foregroundImage: NetworkImage(userImg!)),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user!.fullName),
                        Text(widget.user!.username,
                          style: TextStyle(color: theme.primary.withOpacity(0.5)),)
                      ],
                    )
                  ],
                ),
              ),
              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final isMe = messages[index].senderId==widget.currentUserId;
                    final bool isPreviousSameUser = index < messages.length - 1 &&
                        messages[index].senderId == messages[index + 1].senderId;
                    final bool isLastFromUser = index == 0 ||
                        messages[index].senderId != messages[index - 1].senderId;



                    return Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isMe && isLastFromUser) InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ProfileScreen(profileID: widget.user!.uid),
                          ),
                          ),
                            child: CircleAvatar(foregroundImage: NetworkImage(userImg!))),
                        if (!isMe && !isLastFromUser) SizedBox(width: MediaQuery.of(context).size.width*0.1),
                          InkWell(
                          onLongPress: () {
                            if (isMe) {
                              showDialog(context: context, builder: (context){
                                return Dialog(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.1,
                                    color: theme.inversePrimary,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ListTile(
                                            onTap: () async{
                                              bool? confirmDelete = await showConfirmationDialog(context,
                                                  "Delete message", "Are you sure you want to delete this message?");
                                              if (confirmDelete == true) await provider.deleteMessage(widget.chatId, messages[index].messageId!);
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(Icons.delete, size: 24, color: theme.primary),
                                            title: Text("Delete message"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7),
                            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isMe ? 12 : isPreviousSameUser ? 0 : 12),
                                topRight: Radius.circular(isMe ? (isPreviousSameUser ? 0 : 12) : 12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Text(messages[index].message,
                              style: TextStyle(color: isMe ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        controller: formControllers.message,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          filled: true,
                          fillColor: theme.inversePrimary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: (){
                          if (formControllers.message.text.trim().isEmpty) return;
                          provider.sendMessage(ChatModel(
                              chatId: widget.chatId,
                              senderId: widget.currentUserId,
                              receiverId: widget.user!.uid,
                              message: formControllers.message.text.trim(),
                              messageType: "text",
                              timeSent: DateTime.now()
                          ));
                          formControllers.message.clear();
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
    );
  }
}
