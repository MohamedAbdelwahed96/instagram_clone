import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/presentation/skeleton_loading/post_widget_loading.dart';
import 'package:instagram_clone/data/post_model.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/profile_screen.dart';
import 'package:instagram_clone/presentation/widgets/video_player_widget.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;


import 'icons_widget.dart';

class PostWidget extends StatefulWidget {
  final PostModel model;
  const PostWidget({super.key, required this.model});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String? img;
  List<String>? postMedia;
  bool isSaved = false;
  bool isFav = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final media = Provider.of<MediaProvider>(context, listen: false);
    UserModel? userModel = await user.getUserInfo(widget.model.uid);
    String profilePicture = await media.getImage(bucketName: "images", folderName: "uploads", fileName: userModel!.pfpUrl);
    List<String> imgs = await media.getImages(bucketName: "posts", folderName: widget.model.postId);
    bool like = await user.checkLike(userID: user.currentUser!.uid, postID: widget.model.postId);
    setState(() {
      img = profilePicture;
      postMedia = imgs;
      isFav = like;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Consumer2<MediaProvider, UserProvider>(
        builder: (context, mediaProvider, userProvider, child){
            return img == null || postMedia!.isEmpty ? SkeletonPostWidget()
                : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 7),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(profileID: widget.model.uid))),
                          child: CircleAvatar(backgroundImage: NetworkImage(img!))),
                      SizedBox(width: 8),
                      TextButton(
                        child: Text(widget.model.username, style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                        onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(profileID: widget.model.uid))),),
                      Spacer(),
                      IconButton(
                          onPressed: () async => await mediaProvider.deletePost(context, widget.model),
                          icon: Icon(Icons.more_horiz)),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.model.mediaUrls.length,
                          onPageChanged: (page) => setState(() => _currentPage = page),
                          itemBuilder: (context, index) {

                            String extension = postMedia![index].substring(postMedia![index].lastIndexOf("."));
                            String? mimeType = lookupMimeType("file$extension");
                            bool isVideo = mimeType!.startsWith("video/");

                            return isVideo? VideoPlayerWidget(videoUrl: postMedia![index])
                                : Image.network(postMedia![index], fit: BoxFit.cover);
                          }),
                      widget.model.mediaUrls.length>1?
                      Positioned(top: 16, right: 16,
                        child: Container(
                          width: 30,
                          height: 22,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Text('${_currentPage + 1}/${widget.model.mediaUrls.length}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      )
                          :SizedBox(),
                    ],
                  ),
                ),
                widget.model.mediaUrls.length > 1?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.model.mediaUrls.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                      width: _currentPage == index ? 10 : 8,
                      height: _currentPage == index ? 10 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? theme.primary : theme.inversePrimary,
                      ),
                    ),
                  ),
                )
                    :SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 11),
                  child: Row(
                    children: [
                      IconButton(onPressed: () {
                        userProvider.likePost(userID: userProvider.currentUser!.uid, postID: widget.model.postId);
                        setState(() => isFav=!isFav);
                      }, icon: isFav==false?Icon(Icons.favorite_border, size: 30)
                          :Icon(Icons.favorite, color: Colors.red, size: 30)),
                      SizedBox(width: 12),
                      IconsWidget(icon: "comment"),
                      SizedBox(width: 12),
                      IconsWidget(icon: "share"),
                      Spacer(),
                      IconsWidget(onTap: ()=> setState(() => isSaved=!isSaved), icon: isSaved==false?"save":"save_filled"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.model.likes.length} Likes"),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.model.username,
                              style: TextStyle(fontWeight: FontWeight.bold, color: theme.primary),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(profileID: widget.model.uid)));
                              },
                            ),
                            TextSpan(
                              text: " ${widget.model.caption}",
                              style: TextStyle(color: theme.primary),
                            ),
                          ],
                        ),
                      ),
                      Text(timeago.format(widget.model.createdAt), style: TextStyle(color: theme.primary.withOpacity(0.5)),)
                    ],
                  ),
                ),
              ],
            ),
          );
    });
  }
}
