import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';

class FollowersWidget extends StatefulWidget {
  final String user;
  const FollowersWidget({super.key, required this.user});

  @override
  State<FollowersWidget> createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // image
                Text("Ahmed")

              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
