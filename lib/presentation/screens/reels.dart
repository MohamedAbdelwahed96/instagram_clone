import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/reel_model.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/profile_screen.dart';
import 'package:instagram_clone/presentation/skeleton_loading/reels_loading.dart';
import 'package:instagram_clone/presentation/widgets/icons_widget.dart';
import 'package:instagram_clone/presentation/widgets/navigation_bot_bar.dart';
import 'package:instagram_clone/presentation/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Reels extends StatefulWidget {
  final ReelModel reel;
  const Reels({super.key, required this.reel});

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  UserModel? user;
  String? image;
  String? videoLink;
  bool isSaved = false;
  bool isLiked = false;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    userProvider.viewReel(reelID: widget.reel.reelId);
    bool follow = await userProvider.checkFollow(widget.reel.userId);

    final fetchedUser = await userProvider.getUserInfo(widget.reel.userId);
    final pfp = await mediaProvider.getImage(bucketName: "images", folderName: "uploads", fileName: fetchedUser!.pfpUrl);
    final video = await mediaProvider.getImage(bucketName: "reels", folderName: widget.reel.reelId, fileName: widget.reel.videoUrl);

    bool like = await userProvider.checkLike(mediaType: "reels", mediaID: widget.reel.reelId);
    bool save = await userProvider.checkSave(mediaType: "Reels", mediaID: widget.reel.reelId);

    setState(() {
      user = fetchedUser;
      image = pfp;
      videoLink = video;
      isLiked = like;
      isSaved = save;
      isFollowing = follow;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(user == null || image == null || videoLink == null) return SkeletonReel();

    return Consumer<UserProvider>(builder: (context, provider, _){
      return Stack(
        children: [
          Center(
            child: VideoPlayerWidget(
                videoUrl: videoLink, tapToPlayPause: true, autoPlay: true, fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.reel.caption,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    IconButton(
                        onPressed: ()=> Navigator.popUntil(context, (route) => route.isFirst),
                        icon: Icon(Icons.close, color: Colors.white, size: 34)),
                  ],
                ),
                SizedBox(height: 8),
                // User details
                Row(
                  children: [
                    InkWell(
                        onTap: ()=> Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProfileScreen(profileID: widget.reel.userId))),
                        child: CircleAvatar(backgroundImage: NetworkImage(image!))),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: user!.username,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ProfileScreen(profileID: widget.reel.userId),
                                    ),
                                  ),
                              ),
                              if (provider.currentUser!.uid != widget.reel.userId) ...[
                                const TextSpan(text: "  ·  "),
                                TextSpan(
                                  text: isFollowing ? "unfollow".tr() : "follow".tr(),
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                      setState(() => isFollowing = !isFollowing);
                                      await provider.followProfile(widget.reel.userId, context);
                                    },
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(timeago.format(widget.reel.createdAt),
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "${widget.reel.views.length} ${"views".tr()}  ·  ${widget.reel.comments.length} ${"comments".tr()}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    IconsWidget(
                        icon: isLiked ? "like_filled" : "like",
                        color: isLiked ? Colors.red : Colors.white,
                        onTap: (){
                          setState(() => isLiked=!isLiked);
                          provider.like(mediaType: "reels", mediaID: widget.reel.reelId);
                        }),
                    SizedBox(width: 18),
                    IconsWidget(icon: "comment", color: Colors.white),
                    SizedBox(width: 18),
                    IconsWidget(icon: "share", color: Colors.white),
                    SizedBox(width: 18),
                    Icon(Icons.more_horiz, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
      },
    );
  }
}
