import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/theme.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/login_screen.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/liked_posts.dart';
import 'package:instagram_clone/presentation/screens/profile_screen/saved_posts.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel user;
  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _){
      final theme = Theme.of(context).colorScheme;
      final themeProvider = Provider.of<ThemeProvider>(context);

      return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.dark_mode),
                        title: Text("dark_theme".tr()),
                      ),
                    ),
                    Switch(
                        value: themeProvider.themeData == darkMode,
                        onChanged: (value) => themeProvider.toggleTheme()),
                  ],
                ),
                ListTile(
                  onTap: () {
                    showDialog(context: context,
                        builder: (context) {
                          return Dialog(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        context.setLocale(Locale("en"));
                                        Navigator.pop(context);
                                      },
                                      leading: Text("EN"),
                                      title: Text("english".tr()),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        context.setLocale(Locale("ar"));
                                        Navigator.pop(context);
                                      },
                                      leading: Text("AR"),
                                      title: Text("arabic".tr()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  leading: Icon(Icons.language),
                  title: Text("change_language".tr()),
                ),
                ListTile(
                  onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => SavedPosts(user: widget.user))),
                  leading: Icon(Icons.bookmark_border),
                  title: Text("saved".tr()),
                ),
                ListTile(
                  onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => LikedPosts(user: widget.user))),
                  leading: ImageIcon(AssetImage("assets/icons/like.png")),
                  title: Text("favorite".tr()),
                ),
                ListTile(
                  onTap: ()async{
                    await provider.signOut(context).then((v){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    });
                  },
                  leading: Icon(Icons.output_rounded),
                  title: Text("signout".tr()),
                ),
                Container(height: 1, color: theme.primary.withOpacity(0.15)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
