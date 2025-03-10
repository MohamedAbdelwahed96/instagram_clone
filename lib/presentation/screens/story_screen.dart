import 'package:flutter/material.dart';
import 'package:instagram_clone/data/story_model.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/profile_screen.dart';
import 'package:instagram_clone/presentation/widgets/video_player_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryScreen extends StatefulWidget {
  final UserModel user;
  const StoryScreen({super.key, required this.user});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentPage=0;
  Timer? _timer;
  List<double> percWatched = [];
  List<StoryModel> stories = [];
  List<String> mediaUrls = [];
  String? pfp;

  @override
  void initState() {
    super.initState();
    _fetchStories();
  }

  void _fetchStories() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    final fetchedStories = await userProvider.getRecentStories(widget.user.uid);
    final profilePic = await mediaProvider.getImage(
        bucketName: "users", folderName: widget.user.uid, fileName: widget.user.pfpUrl);

    final storyMediaUrls = await Future.wait(
      fetchedStories.map((story) => mediaProvider.getImage(
          bucketName: "stories", folderName: story.storyId, fileName: story.mediaUrl),
      ),
    );

    if (mounted) {
      setState(() {
        pfp = profilePic;
        mediaUrls = storyMediaUrls;
        stories = fetchedStories;
        percWatched = List.filled(stories.length, 0);
        if (stories.isNotEmpty) _watchStory();
      });
    }
  }

  void _watchStory() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          if (percWatched[currentPage] + 0.01 < 1) {
            percWatched[currentPage] += 0.01;
          } else {
            percWatched[currentPage] = 1;
            timer.cancel();

            if (currentPage < stories.length - 1) {
              currentPage++;
              _watchStory();
            }
            else {
              if (mounted && Navigator.canPop(context)) {
                _timer?.cancel();
                Navigator.pop(context);
              }
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(stories.isEmpty) return Center(child: CircularProgressIndicator());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_timer == null || !_timer!.isActive) _watchStory();
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: InkWell(
          onTapDown: (details){
            if (details.globalPosition.dx < MediaQuery.of(context).size.width * 0.5) {
            setState(() {
                if(currentPage>0){
                  percWatched[currentPage-1]=0;
                  percWatched[currentPage]=0;
                  currentPage--;
                } else {
                  percWatched[currentPage] = 0;
                }
              });
            } else {
              setState(() {
                if(currentPage<stories.length-1){
                  percWatched[currentPage]=1;
                  currentPage++;
                } else {
                  if (mounted && Navigator.canPop(context)) {
                    _timer?.cancel();
                    Navigator.pop(context);
                  }
                }
              });
            }
          },
          child: Stack(
            children: [
              stories[currentPage].isVideo
                ? VideoPlayerWidget(videoUrl: mediaUrls[currentPage])
                : Image.network(mediaUrls[currentPage],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      children: List.generate(stories.length, (index) {
                        return Expanded(
                          child: LinearPercentIndicator(
                            lineHeight: 3,
                            percent: percWatched[index],
                            progressColor: Colors.grey[400],
                            backgroundColor: Colors.grey[600],
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        spacing: 10,
                        children: [
                          InkWell(
                            onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                  ProfileScreen(profileID: widget.user.uid))),
                              child: CircleAvatar(backgroundImage: NetworkImage(pfp!))),
                          InkWell(
                              onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                  ProfileScreen(profileID: widget.user.uid))),
                              child: Text(widget.user.username, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                          Text(timeago.format(stories[currentPage].createdAt, locale: 'en_short'),
                            style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
