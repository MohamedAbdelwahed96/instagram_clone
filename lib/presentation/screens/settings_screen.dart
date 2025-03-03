import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/theme.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/login_screen.dart';
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
                        title: Text("Dark theme"),
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
                                        provider.setLanguage(userID: widget.user.uid, language: "en");
                                        Navigator.pop(context);
                                      },
                                      leading: Text("EN"),
                                      title: Text("English"),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        context.setLocale(Locale("ar"));
                                        provider.setLanguage(userID: widget.user.uid, language: "ar");
                                        Navigator.pop(context);
                                      },
                                      leading: Text("AR"),
                                      title: Text("Arabic"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  leading: Icon(Icons.language),
                  title: Text("Change Language"),
                ),
                ListTile(
                  onTap: ()async{
                    await Provider.of<UserProvider>(context, listen: false).signOut(context).then((v){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    });
                  },
                  leading: Icon(Icons.output_rounded),
                  title: Text("Signout"),
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
