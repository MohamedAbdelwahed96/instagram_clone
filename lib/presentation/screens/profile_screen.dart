import 'package:flutter/material.dart';
import 'package:instagram_clone/logic/image_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final userProvider = Provider.of<UserProvider>(context, listen: false);
  //     final imageProvider = Provider.of<ImagProvider>(context, listen: false);
  //
  //     if (userProvider.pfpUrl != null) {
  //       await imageProvider.getSingleImage(userProvider.pfpUrl!);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final user = Provider.of<UserProvider>(context).user!;
    // final imgProvider = Provider.of<ImagProvider>(context);
    // imgProvider.getSingleImage(user.pfpUrl);

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: Text(user.username,
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: theme.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.menu, color: theme.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.inversePrimary,
                    backgroundImage: NetworkImage("https://g.top4top.io/p_305csqr42.jpg"),
                    // AssetImage("assets/icons/pfp.png"),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        profileStat(user.postCount.toString(), 'Posts', theme),
                        profileStat(user.followersCount.toString(), 'Followers', theme),
                        profileStat(user.followingCount.toString(), 'Following', theme),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(user.username, style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold)),
              Text('Category/Genre text', style: TextStyle(color: theme.secondary)),
              Text(
                user.bio,
                style: TextStyle(color: theme.primary),
              ),
              Text('Link goes here', style: TextStyle(color: Colors.blue)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(239, 239, 239, 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text('Edit Profile', style: TextStyle(color: theme.primary)),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.settings, color: theme.primary),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) => profileStory(theme)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.grid_on, color: theme.primary),
                  Icon(Icons.video_library_outlined, color: theme.primary),
                  Icon(Icons.person_pin_outlined, color: theme.primary),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                    color: theme.inversePrimary,
                    child: Image.asset('assets/images/AshleyMatt.png', fit: BoxFit.cover),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileStat(String number, String label, ColorScheme theme) {
    return Column(
      children: [
        Text(number, style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: theme.secondary)),
      ],
    );
  }

  Widget profileStory(ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.inversePrimary,
            backgroundImage: AssetImage("assets/icons/pfp.png"),
          ),
          Text('Text here', style: TextStyle(color: theme.primary)),
        ],
      ),
    );
  }
}
