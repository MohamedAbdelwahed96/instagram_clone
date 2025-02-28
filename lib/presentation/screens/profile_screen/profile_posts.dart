import 'package:flutter/material.dart';
import 'package:instagram_clone/data/post_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/skeleton_loading/profile_posts_loading.dart';
import 'package:instagram_clone/presentation/widgets/video_player_widget.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class ProfilePosts extends StatefulWidget {
  final List<String> postIDs;
  const ProfilePosts({super.key, required this.postIDs});

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  List<PostModel>? _posts;
  List<String>? _mediaUrls;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    List<PostModel> fetchedPosts = [];
    List<String> fetchedMediaUrls = [];

    for (String postID in widget.postIDs) {
      PostModel? post = await userProvider.getPostInfo(postID);
      if (post != null) {
        String? mediaUrl = await mediaProvider.getImage(
            bucketName: "posts", folderName: postID, fileName: post.mediaUrls[0]);

        fetchedPosts.add(post);
        fetchedMediaUrls.add(mediaUrl);
      }
    }

    setState(() {
      _posts = fetchedPosts;
      _mediaUrls = fetchedMediaUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_posts == null || _mediaUrls == null) return SkeletonProfilePost();

    return _posts!.isNotEmpty
        ? GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _posts!.length,
      itemBuilder: (context, index) {
        final reversedIndex = _posts!.length - 1 - index;
        final post = _posts![reversedIndex];
        final imgUrl = _mediaUrls![reversedIndex];

        String extension = imgUrl.substring(imgUrl.lastIndexOf("."));
        String? mimeType = lookupMimeType("file$extension");
        bool isVideo = mimeType!.startsWith("video/");

        return Stack(
          children: [
            SizedBox.expand(
              child: isVideo
                  ? VideoPlayerWidget(videoUrl: imgUrl)
                  : Image.network(imgUrl, fit: BoxFit.cover),
            ),
            post.mediaUrls.length > 1
                ? Positioned(top: 10, right: 10,
              child: Icon(Icons.copy, color: Colors.white),
            )
                : SizedBox(),
          ],
        );
      },
    )
        : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 65,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.photo_camera_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "No Posts Yet",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
