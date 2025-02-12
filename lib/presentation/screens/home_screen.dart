import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/widgets/icons_widget.dart';
import 'package:instagram_clone/presentation/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 52),
              child: Row(
                children: [
                  Image.asset("assets/images/Logo.png",
                    width: MediaQuery.of(context).size.width*0.26,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar()
                ],
              ),
            ),
            PostWidget(),
          ],
        ),
      ),
    );
  }
}
