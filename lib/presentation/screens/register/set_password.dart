// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_clone/logic/user_provider.dart';
// import 'package:instagram_clone/presentation/screens/login_screen.dart';
// import 'package:instagram_clone/presentation/screens/register/set_email.dart';
// import 'package:instagram_clone/presentation/widgets/button_widget.dart';
// import 'package:instagram_clone/presentation/widgets/text_formfield_widget.dart';
// import 'package:provider/provider.dart';
//
// class SignUpPassword extends StatefulWidget {
//   const SignUpPassword({super.key});
//
//   @override
//   State<SignUpPassword> createState() => _SignUpPasswordState();
// }
//
// class _SignUpPasswordState extends State<SignUpPassword> {
//   TextEditingController controller = TextEditingController();
//   bool isEnabled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(_onTextChanged);
//   }
//
//   void _onTextChanged() => setState(() => isEnabled = controller.text.length >= 6);
//
//   @override
//   void dispose() {
//     controller.removeListener(_onTextChanged);
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserProvider>(
//         builder: (context, provider, _){
//           return Scaffold(
//             body: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
//               child: Column(
//                 children: [
//                   Text("Create a password", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
//                   SizedBox(height: 10),
//                   Text("For security, your password must be 6 characters or more."),
//                   SizedBox(height: 10),
//                   TextFormfieldWidget(hintText: "Password", obsecure: true, controller: controller),
//                   SizedBox(height: 21),
//                   InkWell(
//                     onTap: isEnabled?() {
//                       Provider.of<UserProvider>(context, listen: false).password = controller.text;
//                       Navigator.push(context,CupertinoPageRoute(builder: (context) => SignUpEmail()));
//                     }:null,
//                     child: ButtonWidget(text: "Next", isEnabled: isEnabled),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Already have an email?",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13,
//                             color: Theme.of(context).colorScheme.secondary),
//                       ),
//                       TextButton(onPressed: () {
//                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),),);
//                       }, child: Text("Login."))
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         }
//     );
//   }
// }
