import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/data/user_model.dart';
import '/logic/media_provider.dart';
import '/logic/user_provider.dart';
import '/presentation/screens/login_screen.dart';
import '/presentation/widgets/button_widget.dart';
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
    final theme = Theme.of(context).colorScheme;
    return Consumer2<UserProvider, MediaProvider>(
        builder: (context, userProvider, mediaProvider, _){
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Logo.png",
                    width: MediaQuery.of(context).size.width * 0.56,
                    color: theme.primary,),
                  TextFormfieldWidget(hintText: "email".tr(), controller: emailController,),
                  SizedBox(height: 21),
                  TextFormfieldWidget(hintText: "password".tr(), controller: passController, obsecure: true),
                  SizedBox(height: 21),
                  TextFormfieldWidget(hintText: "age".tr(), controller: ageController),
                  SizedBox(height: 21),
                  TextFormfieldWidget(hintText: "username".tr(), controller: userNameController),
                  SizedBox(height: 21),
                  TextFormfieldWidget(hintText: "full_name".tr(), controller: fullNameController),
                  InkWell(
                    onTap: ()=> mediaProvider.selectMedia(FileType.image),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 21),
                      child: CircleAvatar(radius: 60,
                          backgroundColor: theme.inversePrimary,
                          foregroundImage: mediaProvider.mediaFile==null?null:FileImage(File(mediaProvider.mediaFile!.path!)),
                          child: Image.asset("assets/icons/pfp.png", color: theme.primary)),
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      await mediaProvider.uploadMedia(context, bucketName: "images", folder: "uploads");
                      final email = emailController.text.trimRight(),
                          pass = passController.text,
                          userName = userNameController.text,
                          fullName= fullNameController.text,
                          pfpUrl=mediaProvider.filename;
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
                    child: ButtonWidget(text: "register".tr()),
                  ),
                  SizedBox(height: 21),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "already_have_an_email".tr(),
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: theme.secondary),
                        ),
                        TextSpan(
                          text: "login".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold, color: theme.primary),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),),),
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
  }
}
