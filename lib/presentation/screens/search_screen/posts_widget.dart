import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/data/post_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/skeleton_loading/home_screen_loading.dart';
import 'package:provider/provider.dart';

class PostsWidget extends StatefulWidget {
  final PostModel? model;
  const PostsWidget({super.key, required this.model});

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  String? userImg;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final media = Provider.of<MediaProvider>(context, listen: false);
    String? firstImg = await media.getImage(bucketName: "posts", folderName: widget.model!.postId, fileName: widget.model!.mediaUrls[0]);
    setState(() => userImg = firstImg);
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(userImg!, fit: BoxFit.cover);
  }
}
