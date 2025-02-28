import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/core/controllers.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/media_provider.dart';
import '/logic/user_provider.dart';
import '/presentation/widgets/edit_text_formfield_widget.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? user;
  String? img;
  final formControllers = FormControllers();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel? fetchedUser = await userProvider.getUserInfo(userProvider.currentUser!.uid);
    String? profilePicture = fetchedUser != null
        ? await Provider.of<MediaProvider>(context, listen: false).getImage(bucketName: "images", folderName: "uploads", fileName: fetchedUser.pfpUrl)
        : null;
        setState(() {
      user = fetchedUser;
      img = profilePicture;
    });
  }

  @override
  void dispose() {
    formControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Consumer<UserProvider>(
        builder: (userContext, userProvider, _){
          
          if (user == null) {
            return Center(child: CircularProgressIndicator());
          }

          formControllers.name.text = user!.fullName;
          formControllers.username.text = user!.username;
          formControllers.website.text = user!.website;
          formControllers.bio.text = user!.bio;
          formControllers.email.text = user!.email;
          formControllers.phone.text = user!.pNumber;
          formControllers.gender.text = user!.gender;

          return Consumer<MediaProvider>(builder: (mediaContext, mediaProvider, img_){
            return PopScope(
              canPop: true,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) return;
                mediaProvider.mediaFile = null;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Edit Profile'),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      mediaProvider.mediaFile = null;
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async{
                        final String name = formControllers.name.text,
                            username = formControllers.username.text,
                            web = formControllers.website.text,
                            bio = formControllers.bio.text,
                            email = formControllers.email.text,
                            phone = formControllers.phone.text,
                            gender = formControllers.gender.text;
                        String pfpUrl = user!.pfpUrl;
              
                        if (mediaProvider.mediaFile != null) {
                          await mediaProvider.uploadImage(context, bucketName: "images", folder: "uploads");
                          pfpUrl = mediaProvider.filename ?? pfpUrl;
                        }
              
                        await userProvider.saveInfo(context, name, username, web, bio, email, phone, gender, pfpUrl)
                            .then((v) {
                              mediaProvider.mediaFile = null;
                              Navigator.pop(context);
                            });
              
                      },
                      child: Text('Done', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: theme.inversePrimary,
                            backgroundImage:
                            mediaProvider.mediaFile==null?NetworkImage(img!):FileImage(File(mediaProvider.mediaFile!.path!)),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () async{
                              await mediaProvider.selectMedia(FileType.image);
                            },
                            child: Text('Change Profile Photo', style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        EditTextFormfieldWidget(name: "Name", controller: formControllers.name),
                        EditTextFormfieldWidget(name: "Username", controller: formControllers.username,
                          inputFormats: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],),
                        EditTextFormfieldWidget(name: "Website", controller: formControllers.website,
                          inputFormats: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],),
                        EditTextFormfieldWidget(name: "Bio", controller: formControllers.bio, maxLines: 2, lineEnabled: false),
                        Container(height: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.15)),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {},
                          child: Text('Switch to Professional Account',
                              style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w400)),),
                        SizedBox(height: 29),
                        Text('Private Information'.tr(),
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                        SizedBox(height: 14),
                        EditTextFormfieldWidget(name: "Email", controller: formControllers.email,),
                        EditTextFormfieldWidget(name: "Phone", controller: formControllers.phone,
                          keyboardType: TextInputType.number,
                          inputFormats: [FilteringTextInputFormatter.digitsOnly],),
                        EditTextFormfieldWidget(name: "Gender", controller: formControllers.gender, dropDown: true, lineEnabled: false),
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
