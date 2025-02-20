import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/data/post_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/skeleton_loading/profile_posts_loading.dart';
import 'package:instagram_clone/presentation/widgets/video_player_widget.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class ProfilePosts extends StatefulWidget {
  final String postID;
  const ProfilePosts({super.key, required this.postID});

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  PostModel? _post;
  String? img;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final usr = Provider.of<UserProvider>(context, listen: false);
    final media = Provider.of<MediaProvider>(context, listen: false);
    PostModel? fetchedPost = await usr.getPostInfo(widget.postID);
    String? firstImg = await media.getImage(bucketName: "posts", folderName: widget.postID, fileName: fetchedPost!.mediaUrls[0]);
    setState(() {
      _post = fetchedPost;
      img = firstImg;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_post == null) {
      return SkeletonProfilePost();
    }
    String extension = img!.substring(img!.lastIndexOf("."));
    String? mimeType = lookupMimeType("file$extension");
    bool isVideo = mimeType!.startsWith("video/");
    return Stack(children: [
      SizedBox.expand(
        child: isVideo? VideoPlayerWidget(videoUrl: img)
            : Image.network(img!, fit: BoxFit.cover),
      ),
      _post!.mediaUrls.length>1?
      Positioned(top: 10, right: 10, child: Icon(Icons.copy, color: Colors.white),)
          :SizedBox(),
    ]);
  }
}
