import 'package:flutter/material.dart';
import 'package:instagram_clone/core/theme.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/image_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/home_screen.dart';
import 'package:instagram_clone/presentation/screens/new_post.dart';
import 'package:instagram_clone/presentation/screens/profile_screen.dart';
import 'package:instagram_clone/presentation/screens/register/set_email_phone.dart';
import 'package:instagram_clone/presentation/screens/register/set_username.dart';
import 'package:provider/provider.dart';

import 'icons_widget.dart';

class NavigationBotBar extends StatefulWidget {
  final UserModel ?user;
  const NavigationBotBar({super.key, this.user});

  @override
  State<NavigationBotBar> createState() => _NavigationBotBarState();
}

class _NavigationBotBarState extends State<NavigationBotBar> {
  int _selectedPageIndex = 0;
  final PageController _pgController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user!;

    return Consumer<ImagProvider>(builder: (context, provider, _){
      return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(), child: Icon(Icons.add)),
        body: PageView(
            controller: _pgController,
            onPageChanged: (index){
              setState(() => _selectedPageIndex=index);
            },
            scrollDirection: Axis.horizontal,
            children: [
              HomeScreen(),
              Container(color: Colors.red),
              NewPostScreen(),
              SetEmailPhone(),
              ProfileScreen()
            ]),
        bottomNavigationBar:
        Theme(data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory), // disable the splash effect
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) => _pgController.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.ease),
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==0?"home_bold":"home"), label: ""),
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==1?"search_bold":"search"), label: ""),
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==2?"reels_bold":"reels"), label: ""),
                BottomNavigationBarItem(icon: IconsWidget(icon: _selectedPageIndex==3?"shop_bold":"shop"), label: ""),
                BottomNavigationBarItem(icon: CircleAvatar(radius: 24, backgroundImage: NetworkImage(provider.image??"")), label: "")
              ],
              // selectedItemColor: Theme.of(context).colorScheme.primary, unselectedItemColor: Colors.grey, backgroundColor: Theme.of(context).colorScheme.surface, iconSize: 36,
            ),
          ),
        ) ,
      );
    });
  }
}
