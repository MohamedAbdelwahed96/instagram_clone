import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/chat_screen.dart';
import 'package:instagram_clone/presentation/screens/edit_profile_screen.dart';
import 'package:instagram_clone/presentation/screens/login_screen.dart';
import 'package:instagram_clone/presentation/skeleton_loading/profile_header_loading.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatefulWidget {
  final String profileID;
  const ProfileHeader({super.key, required this.profileID});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  UserModel? user;
  String? img;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    if (img == null || user == null) {
      return SkeletonProfileHeader();
    }

    return Consumer<UserProvider>(builder: (context, provider, _){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.inversePrimary,
                backgroundImage: NetworkImage(img!),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.15),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    profileStat(user!.posts.length, 'Posts'),
                    InkWell(
                        onTap: (){},
                        child: profileStat(user!.followers.length, 'Followers')),
                    InkWell(
                        onTap: (){},
                        child: profileStat(user!.following.length, 'Following')),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(user!.username, style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold)),
          Text('Category/Genre text', style: TextStyle(color: theme.secondary)),
          Text(user!.bio, style: TextStyle(color: theme.primary)),
          Text('Link goes here', style: TextStyle(color: Colors.blue)),
          SizedBox(height: 10),
          provider.currentUser!.uid!=widget.profileID?
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: toggleFollow,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isFollowing ? Color.fromRGBO(239, 239, 239, 0.2) : Color.fromRGBO(0, 163, 255, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(isFollowing ? 'Unfollow' : 'Follow', style: TextStyle(color: isFollowing ? theme.primary: Colors.white)),
                    )
                ),
              ),
              SizedBox(width: isFollowing ? 10 : 0),
              isFollowing ? Expanded(
                flex: 1,
                child: InkWell(
                    onTap: (){},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(239, 239, 239, 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text('Message' , style: TextStyle(color: theme.primary)),
                    )
                ),
              ): SizedBox(),
            ],
          ) :
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                  },
                  child: Container(
                    height: 45,
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
              InkWell(
                onTap: () {
                  provider.signOut(context).then((v){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width*0.08,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(239, 239, 239, 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.output_rounded, color: theme.primary)),
              ),
            ],
          ),
          SizedBox(height: 10)
        ],
      );
    });
  }

  void fetchData() async {
    final usr = Provider.of<UserProvider>(context, listen: false);
    UserModel? fetchedUser = await usr.getUserInfo(widget.profileID);
    String? profilePicture = fetchedUser != null
        ? await Provider.of<MediaProvider>(context, listen: false).getImage(bucketName: "images", folderName: "uploads", fileName: fetchedUser.pfpUrl)
        : null;
    bool follow = await usr.checkFollow(usr.currentUser!.uid, widget.profileID);
    setState(() {
      user = fetchedUser;
      img = profilePicture;
      isFollowing = follow;
    });
  }

  void toggleFollow() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    await provider.followProfile(provider.currentUser!.uid, widget.profileID);
    bool updatedStatus = await provider.checkFollow(provider.currentUser!.uid, widget.profileID);
    setState(() {
      isFollowing = updatedStatus;
    });
  }

  Widget _buildFollowButtons() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: toggleFollow,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isFollowing ? Color.fromRGBO(239, 239, 239, 0.2) : Color.fromRGBO(0, 163, 255, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(isFollowing ? 'Unfollow' : 'Follow',
                  style: TextStyle(color: isFollowing ? Colors.black : Colors.white)),
            ),
          ),
        ),
        SizedBox(width: isFollowing ? 10 : 0),
        isFollowing
            ? Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatId: "10203040")));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color.fromRGBO(239, 239, 239, 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text('Message', style: TextStyle(color: Colors.black)),
            ),
          ),
        )
            : SizedBox(),
      ],
    );
  }

  Widget _buildEditProfileButtons() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color.fromRGBO(239, 239, 239, 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text('Edit Profile', style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.output_rounded, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

}

Widget profileStat(int number, String label) {
  return Column(
    children: [
      Text(number.toString(), style: TextStyle(fontWeight: FontWeight.w700)),
      Text(label),
    ],
  );
}
