import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/user_model.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/screens/login_screen.dart';
import 'package:instagram_clone/presentation/widgets/button_widget.dart';
import 'package:instagram_clone/presentation/widgets/text_formfield_widget.dart';
import 'package:provider/provider.dart';

class SignUpUsername extends StatefulWidget {
  const SignUpUsername({super.key});

  @override
  State<SignUpUsername> createState() => _SignUpUsernameState();
}

class _SignUpUsernameState extends State<SignUpUsername> {
  TextEditingController controller = TextEditingController();
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() => isEnabled = controller.text.length >= 4);

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
        child: Column(
          children: [
            Text("Choose username", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
            SizedBox(height: 10),
            Text("You can always change it later."),
            SizedBox(height: 10),
            TextFormfieldWidget(hintText: "Username", controller: controller),
            SizedBox(height: 21),
            InkWell(
              onTap: isEnabled?() {
                // UserModel? pote;
                // final usr = Provider.of<UserProvider>(context, listen: false).user!;
                // pote?.username = controller.text;

              }:null,
              child: ButtonWidget(text: "Next", isEnabled: isEnabled),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an email?",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                TextButton(onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),),);
                }, child: Text("Login."))
              ],
            )
          ],
        ),
      ),
    );
  }
}
