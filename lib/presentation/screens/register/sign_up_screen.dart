import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/data/user_model.dart';
import '/logic/media_provider.dart';
import '/logic/user_provider.dart';
import '/presentation/screens/login_screen.dart';
import '/presentation/widgets/button_widget.dart';
import '/presentation/widgets/floating_button_widget.dart';
import '/presentation/widgets/navigation_bot_bar.dart';
import '/presentation/widgets/text_formfield_widget.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController(),
      passController = TextEditingController(),
      ageController = TextEditingController(),
      userNameController = TextEditingController(),
      fullNameController = TextEditingController();
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (userContext, userProvider, user_){
      return Consumer<MediaProvider>(builder: (imgContext, imgProvider, img_){
        return Scaffold(
          floatingActionButton: FloatingButtonWidget(),
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
                    InkWell(
                      onTap: (){
                        imgProvider.selectMedia(FileType.image);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 21),
                        child: CircleAvatar(radius: 60,
                            backgroundColor: Theme.of(imgContext).colorScheme.inversePrimary,
                            foregroundImage: imgProvider.mediaFile==null?null:FileImage(File(imgProvider.mediaFile!.path!)),
                            child: Image.asset("assets/icons/pfp.png", color: Theme.of(context).colorScheme.primary)),
                      ),
                    ),
                    InkWell(
                      onTap: () async{
                        await imgProvider.uploadImage(context);
                        final email = emailController.text.trimRight(),
                            pass = passController.text,
                            userName = userNameController.text,
                            fullName= fullNameController.text,
                            pfpUrl=imgProvider.filename;
                        await userProvider.signUp(context, UserModel(
                                username: userName,
                                fullName: fullName,
                                email: email,
                                gender: "Male",
                                pfpUrl: pfpUrl!,
                                time: DateTime.now()),
                            pass);
                        userProvider.isLogged?Navigator.pushReplacement(context, CupertinoPageRoute(
                            builder: (context) => NavigationBotBar())):null;
                      },
                      child: ButtonWidget(text: "Register"),
                    ),
                    SizedBox(height: 21),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an email?  ',
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Theme.of(context).colorScheme.secondary),
                          ),
                          TextSpan(
                            text: 'Login.',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushReplacement(userContext, MaterialPageRoute(builder: (context) => LoginScreen(),),),
                          ),
                        ],
                      ),
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
