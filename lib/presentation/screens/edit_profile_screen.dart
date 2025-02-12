import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/core/text_input_formats.dart';
import 'package:instagram_clone/logic/image_provider.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/widgets/choose_image_widget.dart';
import 'package:instagram_clone/presentation/widgets/edit_text_formfield_widget.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController bioController = TextEditingController(
      text: 'Digital goodies designer @pixsellz Everything is designed.');
  final TextEditingController emailController =
      TextEditingController(text: 'jacob.west@gmail.com');
  final TextEditingController phoneController =
      TextEditingController(text: '+1 202 555 0147');
  final TextEditingController genderController =
      TextEditingController(text: 'Male');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final user = Provider.of<UserProvider>(context).user!;
    final imgProvider = Provider.of<ImagProvider>(context);

    setState(() {
      nameController.text = user.fullName;
      usernameController.text = user.username;
      websiteController.text;
      bioController.text = user.bio;
      emailController.text = user.email;
      phoneController.text;
      genderController.text;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: Icon(Icons.arrow_back),
        actions: [
          TextButton(
            onPressed: () {},
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
                      NetworkImage("https://g.top4top.io/p_305csqr42.jpg"),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ChooseImageWidget();
                      },
                    );
                  },
                  child: Text('Change Profile Photo',
                      style: TextStyle(color: Colors.blue)),
                ),
              ),
              EditTextFormfieldWidget(name: "Name", controller: nameController),
              EditTextFormfieldWidget(
                name: "Username",
                controller: usernameController,
                inputFormats: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
              ),
              EditTextFormfieldWidget(
                name: "Website",
                controller: websiteController,
                inputFormats: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
              ),
              EditTextFormfieldWidget(
                  name: "Bio",
                  controller: bioController,
                  maxLines: 2,
                  lineEnabled: false),
              Container(
                  height: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15)),
              SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: Text('Switch to Professional Account',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 29),
              Text(
                'Private Information'.tr(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 14),
              EditTextFormfieldWidget(
                name: "Email",
                controller: emailController,
              ),
              EditTextFormfieldWidget(
                name: "Phone",
                controller: phoneController,
                keyboardType: TextInputType.number,
                inputFormats: [FilteringTextInputFormatter.digitsOnly],
              ),
              EditTextFormfieldWidget(
                  name: "Gender", controller: genderController),
            ],
          ),
        ),
      ),
    );
  }
}
