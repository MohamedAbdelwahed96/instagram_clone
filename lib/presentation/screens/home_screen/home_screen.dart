import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/presentation/screens/home_screen/story_widget.dart';
import 'package:instagram_clone/presentation/screens/new_post.dart';
import 'package:instagram_clone/presentation/skeleton_loading/home_screen_loading.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/widgets/icons_widget.dart';
import 'package:instagram_clone/presentation/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel>? users;
  List<String>? pfpUrls;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    await userProvider.getAllPosts();

    List<UserModel> fetchedUsers = [];
    List<String> tempImgUrls = [];

    List<UserModel> fetchedFollowings = await userProvider.getFollowings();
    fetchedUsers.addAll(fetchedFollowings);

    for (UserModel user in fetchedUsers) {
      String pfpUrl = await mediaProvider.getImage(
          bucketName: "images", folderName: "uploads", fileName: user.pfpUrl);
      tempImgUrls.add(pfpUrl);
    }

    UserModel? fetchedUser = await userProvider.getUserInfo(userProvider.currentUser!.uid);
    fetchedUsers.insert(0, fetchedUser!);
    String? profilePicture = await mediaProvider.getImage(
        bucketName: "images", folderName: "uploads", fileName: fetchedUser.pfpUrl);
    tempImgUrls.insert(0, profilePicture);

    setState(() {
      users = fetchedUsers;
      pfpUrls = tempImgUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _) {
      if (provider.posts.isEmpty || pfpUrls == null || users == null) return SkeletonHomeScreen();
      return SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                flexibleSpace: Material(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Image.asset("assets/images/Logo.png",
                            width: MediaQuery.of(context).size.width * 0.26,
                            color: Theme.of(context).colorScheme.primary),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_drop_down),
                        Spacer(),
                        IconsWidget(icon: "fav"),
                        SizedBox(width: 24),
                        IconsWidget(icon: "chat"),
                        SizedBox(width: 24),
                        IconsWidget(icon: "new_story",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewPostScreen())),),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: StoryWidget(users: users!, pfpUrls: pfpUrls!)),
              SliverToBoxAdapter(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.posts.length,
                    itemBuilder: (context, index) => PostWidget(model: provider.posts[index]),
                  )
              )
            ],
          ),
        ),
      );
    });
  }
}
