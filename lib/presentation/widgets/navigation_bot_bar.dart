import 'package:flutter/material.dart';
import 'package:instagram_clone/core/theme.dart';
import 'package:instagram_clone/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'icons_widget.dart';

class NavigationBotBar extends StatefulWidget {
  const NavigationBotBar({super.key});

  @override
  State<NavigationBotBar> createState() => _NavigationBotBarState();
}

class _NavigationBotBarState extends State<NavigationBotBar> {
  int _selectedPageIndex = 0;
  final PageController _pgController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

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
            Container(color: Colors.blue),
            Container(color: Colors.yellow),
            Container(color: Colors.green)
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
                BottomNavigationBarItem(icon: CircleAvatar(), label: "")
              ],
            // selectedItemColor: Theme.of(context).colorScheme.primary, unselectedItemColor: Colors.grey, backgroundColor: Theme.of(context).colorScheme.surface, iconSize: 36,
          ),
        ),
      ) ,
    );
  }
}
