import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:provider/provider.dart';

class TaggedPosts extends StatelessWidget {
  final UserModel user;
  const TaggedPosts({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final thisUser = Provider.of<UserProvider>(context).currentUser!.uid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 65,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.person_pin_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 10),
        thisUser!=user.uid?
        Text(
          "no_posts_yet".tr(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ):
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "tagged_media".tr(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.5),
            children: [
              TextSpan(
                text: "tagged_desc".tr(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5))
              )
            ]
          ),
        )
      ],
    );
  }
}
