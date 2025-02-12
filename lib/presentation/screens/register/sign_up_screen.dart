import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/theme.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/image_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/login_screen.dart';
import 'package:instagram_clone/presentation/widgets/button_widget.dart';
import 'package:instagram_clone/presentation/widgets/choose_image_widget.dart';
import 'package:instagram_clone/presentation/widgets/navigation_bot_bar.dart';
import 'package:instagram_clone/presentation/widgets/text_formfield_widget.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (userContext, userProvider, user_){
      return Consumer<ImagProvider>(builder: (imgContext, imgProvider, img_){
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/Logo.png",
                      width: MediaQuery.of(userContext).size.width * 0.56,
                      color: Theme.of(userContext).colorScheme.primary,),
                    TextFormfieldWidget(hintText: "Email", controller: emailController,),
                    SizedBox(height: 21),
                    TextFormfieldWidget(hintText: "Password", controller: passController, obsecure: true),
                    SizedBox(height: 21),
                    TextFormfieldWidget(hintText: "Age", controller: ageController),
                    SizedBox(height: 21),
                    TextFormfieldWidget(hintText: "username", controller: userNameController),
                    SizedBox(height: 21),
                    TextFormfieldWidget(hintText: "Full Name", controller: fullNameController),
                    SizedBox(height: 21),
                    InkWell(
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseImageWidget();
                          },
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(radius: 60,
                              backgroundColor: Theme.of(imgContext).colorScheme.inversePrimary,
                              foregroundImage: imgProvider.ImageFile==null?null:FileImage(imgProvider.ImageFile!),
                              child: Image.asset("assets/icons/pfp.png", color: Theme.of(context).colorScheme.primary,)),
                        ],
                      ),
                    ),
                    SizedBox(height: 21),
                    InkWell(
                      onTap: () async{
                        final email = emailController.text.trimRight(),
                            pass = passController.text,
                            userName = userNameController.text,
                            fullName= fullNameController.text,
                            pfpUrl=imgProvider.filename;
            
                        if(await userProvider.signUp(userContext, UserModel(
                            username: userName, fullName: fullName, pfpUrl: pfpUrl.toString(), email: email, time: DateTime.now()),
                            email, pass)) {
                          imgProvider.uploadImage(context);
                          Navigator.pushReplacement(userContext, CupertinoPageRoute(builder: (context) => NavigationBotBar()));
                        }
                      },
                      child: ButtonWidget(text: "Register"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an email?",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Theme.of(userContext).colorScheme.secondary),
                        ),
                        TextButton(onPressed: () {
                          Navigator.pushReplacement(userContext, MaterialPageRoute(builder: (context) => LoginScreen(),),);
                        }, child: Text("Login."))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
