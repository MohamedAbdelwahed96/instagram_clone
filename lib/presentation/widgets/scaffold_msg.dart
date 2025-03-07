import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/presentation/screens/new_post.dart';
import 'package:instagram_clone/presentation/screens/new_reel.dart';
import 'package:instagram_clone/presentation/screens/new_story.dart';
import 'package:instagram_clone/presentation/widgets/icons_widget.dart';

void showScaffoldMSG(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg.tr(),
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      action: SnackBarAction(
        label: "dismiss".tr(),
        textColor: Theme.of(context).colorScheme.primary,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
      behavior: SnackBarBehavior.floating, // Optional: Floating style
    ),
  );
}

void addNew(BuildContext context) {
  showModalBottomSheet(context: context,
    builder: (context) {
      final screen = MediaQuery.of(context).size;
      return SizedBox(
        height: screen.height * 0.33,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(child: Text("create".tr(), style: TextStyle(fontSize: 24))),
            ),
            Container(height: 1, width: screen.width,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),),
            listTile(context, "reels", screen.width * 0.75, "new reel".tr(), NewReel()),
            listTile(context, Icons.grid_on, screen.width * 0.75, "new post".tr(), NewPostScreen()),
            listTile(context, "story", screen.width * 0.75, "new story".tr(), NewStory()),
          ],
        ),
      );
    },
  );
}

Widget listTile(BuildContext context, dynamic icon, double width, String title, Widget widget) {
  return Column(
    children: [
      ListTile(
        leading: icon is IconData ? Icon(icon) : IconsWidget(icon: icon),
        title: Text(title, style: TextStyle(fontSize: 18)),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
        }),
      Container(height: 1, width: width,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
      )
    ],
  );
}