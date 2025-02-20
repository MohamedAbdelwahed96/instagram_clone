import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/widgets/followers_widget.dart';
import 'package:provider/provider.dart';

class FollowersScreen extends StatefulWidget {
  final String userID;
  const FollowersScreen({super.key, required this.userID});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  UserModel? user;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final usr =  Provider.of<UserProvider>(context, listen: false);
    UserModel? fetchedUser = await usr.getUserInfo(widget.userID);
    setState(() {
      user = fetchedUser;
    });
  }

  void toggleFollow() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    await provider.followProfile(provider.currentUser!.uid, widget.userID);
    bool updatedStatus = await provider.checkFollow(provider.currentUser!.uid, widget.userID);
    setState(() {
      isFollowing = updatedStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Consumer<UserProvider>(builder: (userContext, userProvider, user_){
      return Consumer<MediaProvider>(builder: (mediaContext, mediaProvider, media_){
        return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(user!.username),
                bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Theme.of(context).colorScheme.secondary.withOpacity(.5),
                    tabs: [Tab(text: "${user!.followers.length} followers"), Tab(text: "${user!.following.length} following")]),
              ),
              body: TabBarView(children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: user!.followers.length,
                        itemBuilder: (context,index){
                          final x = user!.followers[index];
                          return Column(
                            children: [
                              FollowersWidget(user: x),
                              SizedBox(height: 10)
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Container(
                  // height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // image
                            Text("Ahmed"),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              width: MediaQuery.of(context).size.width*.25,
                              decoration: BoxDecoration(
                                color: isFollowing ? Color.fromRGBO(239, 239, 239, 0.2) : Color.fromRGBO(0, 163, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(isFollowing ? 'Unfollow' : 'Follow', style: TextStyle(color: isFollowing ? theme.primary: Colors.white)),
                            )

                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                )

                // Padding(
                //   padding: EdgeInsets.all(16),
                //   child: Column(
                //     children: [
                //
                //     ],
                //   ),
                // )
              ]),
            ));
      });
    });
  }
}
