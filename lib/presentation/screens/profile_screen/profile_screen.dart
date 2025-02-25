import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/new_post.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/profile_header.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/profile_posts.dart';
import 'package:instagram_clone/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String profileID;
  const ProfileScreen({super.key, required this.profileID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    UserModel? fetchedUser =
    await Provider.of<UserProvider>(context, listen: false).getUserInfo(widget.profileID);
    setState(() => _user = fetchedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _){
      if (_user == null) {
        return Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        appBar: provider.currentUser!.uid!=widget.profileID?
        AppBar(
          title: Text(_user!.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          centerTitle: true,
          leading: Icon(Icons.arrow_back_ios_new),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            moreOptions(),
          ],
        )
            :AppBar(
          title: Text(_user!.username, style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPostScreen())),
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen())),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, isScrolled){
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ProfileHeader(profileID: widget.profileID),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: MyDelegate(
                      TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.grid_on)),
                          Tab(icon: Icon(Icons.favorite_border_outlined)),
                          Tab(icon: Icon(Icons.bookmark_border)),
                        ],
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: Color.fromRGBO(196, 196, 196, 1),
                      )
                  ),
                  floating: true,
                  pinned: true,
                )
              ];
            },
            body: TabBarView(
                children: [
                  postsGrid(),
                  postsGrid(),
                  postsGrid()
                ]
            ),
          ),
        ),
      );
    });
  }

  Widget postsGrid() {
    return _user!.posts.isNotEmpty?
    GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _user!.posts.length,
      itemBuilder: (context, index) {
        final reversedIndex = _user!.posts.length - 1 - index;
        return ProfilePosts(postID: _user!.posts[reversedIndex]);
      },
    )
    :Column(
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
        Text("No Posts Yet",
          style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),)
      ],
    );
  }

  Widget moreOptions(){
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz),
      color: Theme.of(context).colorScheme.surface,
      onSelected: (String value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
        value == "Photos" ? Container(color: Colors.red)
            : value == "Videos" ? Container(color: Colors.yellow)
            : value == "Settings" ? Container(color: Colors.pink)
            : SizedBox(),
          ),
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: "Photos", child: Text("Photos & Screens")),
        PopupMenuItem(value: "Videos", child: Text("Videos")),
        PopupMenuItem(value: "Settings", child: Text("Settings")),
      ],
    )
    ;
  }

// Widget profileStory(ColorScheme theme) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//     child: Column(
//       children: [
//         CircleAvatar(
//           radius: 30,
//           backgroundColor: theme.inversePrimary,
//           backgroundImage: AssetImage("assets/icons/pfp.png"),
//         ),
//         Text('Text here', style: TextStyle(color: theme.primary)),
//       ],
//     ),
//   );
// }
}

class MyDelegate extends SliverPersistentHeaderDelegate{
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Theme.of(context).colorScheme.surface, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}