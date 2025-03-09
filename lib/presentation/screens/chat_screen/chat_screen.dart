import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/controllers.dart';
import 'package:instagram_clone/data/chat_model.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/chat_provider.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/presentation/screens/chat_screen/chat_messages.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final UserModel? user;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.user,
  });

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
    if (userImg == null) return CircularProgressIndicator();

    final theme = Theme.of(context).colorScheme;
    final screen = MediaQuery.of(context).size;

    return Consumer<ChatProvider>(builder: (context, provider, _) {
        final messages = provider.chats[widget.chatId] ?? [];
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),
                      CircleAvatar(foregroundImage: NetworkImage(userImg!)),
                      SizedBox(width: screen.width * 0.025),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.user!.fullName),
                          Text(widget.user!.username,
                            style: TextStyle(color: theme.primary.withOpacity(0.5)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ChatMessages(chatId: widget.chatId,
                    currentUserId: widget.currentUserId,
                    userImg: userImg,
                    messages: messages),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 3,
                          controller: formControllers.message,
                          decoration: InputDecoration(
                            hintText: "type_message".tr(),
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
                        onPressed: () {
                          if (formControllers.message.text.trim().isEmpty) return;
                          provider.sendMessage(ChatModel(
                            chatId: widget.chatId,
                            senderId: widget.currentUserId,
                            receiverId: widget.user!.uid,
                            message: formControllers.message.text.trim(),
                            messageType: "text",
                            timeSent: DateTime.now(),
                          ));
                          formControllers.message.clear();
                        },
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
