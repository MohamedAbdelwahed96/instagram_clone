import 'package:flutter/material.dart';

import 'icons_widget.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isSaved=false;
  bool isFav=false;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 7),
            child: Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 8),
                Text("User", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                Spacer(),
                Icon(Icons.more_horiz)
              ],
            ),
          ),
          Image.asset("assets/images/AshleyMatt.png",),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 11),
            child: Row(
              children: [
                IconsWidget(onTap: (){setState(() => isFav=!isFav);}, icon: isFav==false?"fav":"fav_filled"),
                SizedBox(width: 12),
                IconsWidget(icon: "comment"),
                SizedBox(width: 12),
                IconsWidget(icon: "share"),
                Spacer(),
                IconsWidget(onTap: (){setState(() => isSaved=!isSaved);}, icon: isSaved==false?"save":"save_filled"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text("100 Likes"),
                Text("Username Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"),
              ],
            ),
          ),
        ],
      )
    ;
  }
}
