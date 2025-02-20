import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _){
      if (provider.posts.isEmpty) {
        return SkeletonHomeScreen();
      }

      return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 14, left: 14, top: 52),
              child: Row(
                children: [
                  Image.asset("assets/images/Logo.png",
                    width: MediaQuery.of(context).size.width * 0.26,
                    color: Theme.of(context).colorScheme.primary,),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_drop_down),
                  Spacer(),
                  IconsWidget(icon: "fav"),
                  SizedBox(width: 24),
                  IconsWidget(icon: "chat"),
                  SizedBox(width: 24),
                  IconsWidget(icon: "new_story"),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: provider.posts.length,
                itemBuilder: (context,index){
                  final reversedIndex = provider.posts.length - 1 - index;
                  final post = provider.posts[reversedIndex];
                  return PostWidget(model: post);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
