import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/chat_screen.dart';
import 'package:instagram_clone/presentation/screens/search_screen/search_screen.dart';
import 'package:provider/provider.dart';
import '/presentation/widgets/floating_button_widget.dart';
import '/presentation/screens/home_screen.dart';
import '/presentation/screens/new_post.dart';
import '../screens/profile_screen/profile_screen.dart';

import 'icons_widget.dart';

class NavigationBotBar extends StatefulWidget {
  const NavigationBotBar({super.key});

  @override
  State<NavigationBotBar> createState() => _NavigationBotBarState();
}

class _NavigationBotBarState extends State<NavigationBotBar> {
  UserModel? user;
  String? img;
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final userProvider =  Provider.of<UserProvider>(context, listen: false);
    UserModel? fetchedUser = await userProvider.getUserInfo(userProvider.currentUser!.uid);
    String? ProfilePicture = fetchedUser != null ?
    await Provider.of<MediaProvider>(context, listen: false).getImage(bucketName: "images", folderName: "uploads", fileName: fetchedUser.pfpUrl)
        : null;
    setState(() {
      user = fetchedUser;
      img = ProfilePicture;
    });
  }

  int _selectedPageIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(builder: (context, provider, _){
      if (img == null || user == null) {
        return Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        // floatingActionButton: FloatingButtonWidget(),
        body: PageView(
            controller: _controller,
            onPageChanged: (index)=> setState(() => _selectedPageIndex=index),
            scrollDirection: Axis.horizontal,
            children: [
              HomeScreen(),
              SearchScreen(),
              ChatScreen(chatId: "10203040"),
              ProfileScreen(profileID: "ZRtVkyk9d5YXEqhuVgCj3Esja8v2"),
              ProfileScreen(profileID: user!.uid)
            ]),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory), // disable the splash effect
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedPageIndex,
              onTap: (index) => _controller.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.ease),
              items: [
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==0?"home_bold":"home"), label: ""),
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==1?"search_bold":"search"), label: ""),
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==2?"reels_bold":"reels"), label: ""),
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==3?"shop_bold":"shop"), label: ""),
                BottomNavigationBarItem(icon: CircleAvatar(radius: 24, backgroundImage: NetworkImage(img!)), label: "")
              ],
              // selectedItemColor: Theme.of(context).colorScheme.primary, unselectedItemColor: Colors.grey, backgroundColor: Theme.of(context).colorScheme.surface, iconSize: 36,
            ),
          ),
        ) ,
      );
    });
  }
}
