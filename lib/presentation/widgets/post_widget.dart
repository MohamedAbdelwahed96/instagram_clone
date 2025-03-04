import 'package:easy_localization/easy_localization.dart';
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
import 'confirm_message.dart';
import 'icons_widget.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String? img;
  List<String>? postMedia;
  bool isSaved = false;
  bool isLiked = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final media = Provider.of<MediaProvider>(context, listen: false);
    UserModel? userModel = await user.getUserInfo(widget.post.uid);
    String profilePicture = await media.getImage(bucketName: "images", folderName: "uploads", fileName: userModel!.pfpUrl);
    List<String> imgs = await media.getImages(bucketName: "posts", folderName: widget.post.postId);
    bool like = await user.checkLike(userID: user.currentUser!.uid, postID: widget.post.postId);
    bool save = await user.checkSave(userID: user.currentUser!.uid, postID: widget.post.postId);
    setState(() {
      img = profilePicture;
      postMedia = imgs;
      isLiked = like;
      isSaved = save;
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
                  padding: const EdgeInsets.only(left: 13),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(profileID: widget.post.uid))),
                          child: CircleAvatar(backgroundImage: NetworkImage(img!))),
                      SizedBox(width: 8),
                      TextButton(
                        child: Text(widget.post.username, style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                        onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(profileID: widget.post.uid))),),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == "Delete") {
                              bool? confirmDelete = await showConfirmationDialog(
                                  context, "delete_post".tr(),
                                  "confirm_delete_post".tr());
                              if (confirmDelete == true) {
                                await mediaProvider.deletePost(context, widget.post);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            if (widget.post.uid == userProvider.currentUser!.uid)
                              PopupMenuItem(value: "Delete", child: Text("delete".tr()),),
                          ],
                          icon: Icon(Icons.more_horiz),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.post.mediaUrls.length,
                          onPageChanged: (page) => setState(() => _currentPage = page),
                          itemBuilder: (context, index) {

                            String extension = postMedia![index].substring(postMedia![index].lastIndexOf("."));
                            String? mimeType = lookupMimeType("file$extension");
                            bool isVideo = mimeType!.startsWith("video/");

                            return isVideo? VideoPlayerWidget(videoUrl: postMedia![index])
                                : Image.network(postMedia![index], fit: BoxFit.cover);
                          }),
                      widget.post.mediaUrls.length>1?
                      Positioned(top: 16, right: 16,
                        child: Container(
                          width: 30,
                          height: 22,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Text('${_currentPage + 1}/${widget.post.mediaUrls.length}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      )
                          :SizedBox(),
                    ],
                  ),
                ),
                widget.post.mediaUrls.length > 1?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.post.mediaUrls.length,
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
                      IconsWidget(
                        icon: isLiked ? "fav_filled" : "fav",
                        color: isLiked ? Colors.red : Theme.of(context).colorScheme.primary,
                        onTap: (){
                          final userID = userProvider.currentUser!.uid;
                          setState(() {
                            isLiked=!isLiked;
                            if (isLiked) {
                              widget.post.likes.add(userID);
                            } else {
                              widget.post.likes.remove(userID);
                            }
                          });
                          userProvider.likePost(userID: userID, postID: widget.post.postId);
                        }),
                      SizedBox(width: 12),
                      IconsWidget(icon: "comment"),
                      SizedBox(width: 12),
                      IconsWidget(icon: "share"),
                      Spacer(),
                      IconsWidget(onTap: () {
                        final userID = userProvider.currentUser!.uid;
                        userProvider.savePost(context, userID: userID, postID: widget.post.postId);
                        setState(() => isSaved=!isSaved);
                      }, icon: isSaved==false?"save":"save_filled"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.post.likes.length} ${"likes".tr()}"),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.post.username,
                              style: TextStyle(fontWeight: FontWeight.bold, color: theme.primary),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(profileID: widget.post.uid)));
                              },
                            ),
                            TextSpan(
                              text: " ${widget.post.caption}",
                              style: TextStyle(color: theme.primary),
                            ),
                          ],
                        ),
                      ),
                      Text(timeago.format(widget.post.createdAt), style: TextStyle(color: theme.primary.withOpacity(0.5)),)
                    ],
                  ),
                ),
              ],
            ),
          );
    });
  }
}
