import 'package:flutter/material.dart';
import 'package:instagram_clone/data/post_model.dart';
import 'package:instagram_clone/logic/image_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/widgets/button_widget.dart';
import 'package:instagram_clone/presentation/widgets/choose_image_widget.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);

    return Consumer<ImagProvider>(
      builder: (context, provider, _){
        return Scaffold(
          appBar: AppBar(
            title: Text("New Post"),
            centerTitle: true,
            leading: Icon(Icons.arrow_back),
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
              InkWell(
                onTap: (){ChooseImageWidget();},
                child: Container(
                  height: 250,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: provider.ImageFile == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Theme.of(context).colorScheme.secondary)
                      : Image.file(provider.ImageFile!, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _captionController,
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  user.uploadPost(
                      PostModel(
                      postId: postId,
                      uid: user.usercd.uid,
                      username: user.username!,
                      userProfileImage: userProfileImage,
                      postImageUrl: postImageUrl,
                      caption: _captionController.text,
                      createdAt: DateTime.now(),
                      likes: [],
                      commentCount: 0),
                  );
                }, // upload post
                child: ButtonWidget(text: "Post"),
              ),
            ],
          ),
        );
      }
    );
  }
}
