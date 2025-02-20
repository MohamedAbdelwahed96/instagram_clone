import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/presentation/widgets/navigation_bot_bar.dart';
import 'package:instagram_clone/presentation/widgets/scaffold_msg.dart';
import 'package:instagram_clone/presentation/widgets/video_player_widget.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import '/data/post_model.dart';
import '/logic/media_provider.dart';
import '/logic/user_provider.dart';
import '/presentation/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  PageController _pageController = PageController();
  UserModel? user;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final usr = Provider.of<UserProvider>(context, listen: false);
    UserModel? fetchedUser = await usr.getUserInfo(usr.currentUser!.uid);
    setState(() => user = fetchedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(
        builder: (context, provider, _){
          return Scaffold(
            appBar: AppBar(
              title: Text("New Post"),
              centerTitle: true,
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.pop(context)),
              actions: [
                _isUploading
                    ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : IconButton(
                  icon: Icon(Icons.upload),
                  onPressed: (){}, // upload post
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: provider.mediaFiles.isEmpty
                        ?Center(
                          child: IconButton(
                          onPressed: ()async => await provider.selectMedia(FileType.media, multiple: true),
                          icon: Icon(Icons.add_a_photo, size: 50, color: Theme.of(context).colorScheme.secondary)),
                        ) :
                    PageView.builder(
                        controller: _pageController,
                        itemCount: provider.mediaFiles.length,
                        itemBuilder: (context, index) {
                          final file = provider.mediaFiles[index];
                          final path = file.path!;
                  
                          if(lookupMimeType(path)!.startsWith("video/")) {
                            return VideoPlayerWidget(videoFile: File(path));
                          } else if(lookupMimeType(path)!.startsWith("image/")) {
                              return Image.file(File(file.path!), fit: BoxFit.fitHeight,);
                            }
                          return null;
                          })
                      ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      hintText: "Write a caption...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: InkWell(
                    onTap: ()async{
                      final postID = const Uuid().v1();
                      await provider.uploadMedia(context, postID);
                      print("Filename after upload: ${provider.filename}");
                      if (provider.filename == null) {
                        showScaffoldMSG(context, "Upload failed: No filename generated.");
                        return;
                      }
                      await provider.uploadPost(context,
                        PostModel(
                            postId: postID,
                            uid: user!.uid,
                            username: user!.username,
                            userProfileImage: user!.pfpUrl,
                            mediaUrls: provider.media,
                            caption: _captionController.text,
                            createdAt: DateTime.now(),
                            likes: [],
                            commentCount: 0)
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBotBar()));
                    }, // upload post
                    child: ButtonWidget(text: "Post"),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
