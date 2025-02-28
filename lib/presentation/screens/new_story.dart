import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/controllers.dart';
import 'package:instagram_clone/data/story_model.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/widgets/button_widget.dart';
import 'package:instagram_clone/presentation/widgets/navigation_bot_bar.dart';
import 'package:instagram_clone/presentation/widgets/video_player_widget.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewStory extends StatefulWidget {
  const NewStory({super.key});

  @override
  State<NewStory> createState() => _NewStoryState();
}

class _NewStoryState extends State<NewStory> {
  final formControllers = FormControllers();
  UserModel? user;
  bool _isUploading = false;
  bool _isVideo = false;

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
  void dispose() {
    formControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(builder: (context, provider, _){
      return Scaffold(
        appBar: AppBar(
          title: Text("Add to story"),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.pop(context)),
          actions: [
            _isUploading
                ? Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircularProgressIndicator(color: Colors.white),)
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
                child: provider.mediaFile==null
                    ? Center(child: IconButton(
                    onPressed: () async {
                      await provider.selectMedia(FileType.media);
                      setState(() => _isVideo = lookupMimeType(provider.mediaFile!.path!)!.startsWith("video/"));
                    },
                    icon: Icon(Icons.add_a_photo, size: 50, color: Theme.of(context).colorScheme.secondary)),) :
                _isVideo?
                VideoPlayerWidget(videoFile: File(provider.mediaFile!.path!)):
                // lookupMimeType(provider.mediaFile!.path!)!.startsWith("image/")?
                Image.file(File(provider.mediaFile!.path!), fit: BoxFit.fitHeight)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: InkWell(
                onTap: () async{
                  final storyID = const Uuid().v1();
                  await provider.uploadImage(context, bucketName: "stories", folder: storyID);
                  if (provider.filename == null) return;
                  await provider.uploadStory(context,
                      StoryModel(
                          storyId: storyID,
                          userId: user!.uid,
                          mediaUrl: provider.filename!,
                          isVideo: _isVideo,
                          createdAt: DateTime.now())
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBotBar()));
                }, // upload post
                child: ButtonWidget(text: "Post"),
              ),
            ),
          ],
        ),
      );
    });
  }
}
