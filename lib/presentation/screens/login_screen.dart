import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/theme.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/register/sign_up_screen.dart';
import 'package:instagram_clone/presentation/widgets/button_widget.dart';
import 'package:instagram_clone/presentation/widgets/navigation_bot_bar.dart';
import 'package:instagram_clone/presentation/widgets/text_formfield_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, provider, _){
      return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(), child: Icon(Icons.add)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/Logo.png",
                  width: MediaQuery.of(context).size.width*0.56,
                  color: Theme.of(context).colorScheme.primary,),
                TextFormfieldWidget(hintText: "Email", controller: emailController),
                SizedBox(height: 21),
                TextFormfieldWidget(hintText: "Password", controller: passController, obsecure: true),
                SizedBox(height: 21),
                InkWell(
                  onTap: () async{
                    final email = emailController.text.trimRight();
                    final pass = passController.text;
                    if(await provider.signIn(context, email, pass)) {
                      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => NavigationBotBar()));
                    }
                  },
                  child: ButtonWidget(text: "Login"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do not have an email?",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    TextButton(onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen(),),);
                    }, child: Text("Register."))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
