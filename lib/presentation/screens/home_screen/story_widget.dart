import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/presentation/screens/new_story.dart';
import 'package:instagram_clone/presentation/screens/story_screen.dart';

class StoryWidget extends StatelessWidget {
  final List<UserModel> users;
  final List<String> pfpUrls;
  const StoryWidget({super.key, required this.users, required this.pfpUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.22,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          if (index != 0 && users[index].stories.isEmpty) return SizedBox();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
              users[index].stories.isNotEmpty ? StoryScreen(user: users[index])
                  : NewStory(),),),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.orange, Colors.yellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface),
                      padding: EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.08,
                        backgroundImage: NetworkImage(pfpUrls[index]),
                      ),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      bottom: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02,
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewStory())),
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.036,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.03,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
