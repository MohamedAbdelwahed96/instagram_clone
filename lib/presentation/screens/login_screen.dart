import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/theme.dart';
import 'package:instagram_clone/logic/sign_in_bloc/cubit.dart';
import 'package:instagram_clone/logic/sign_in_bloc/state.dart';
import 'package:instagram_clone/presentation/screens/sign_up_screen.dart';
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
    return BlocProvider(create: (context)=>SignInCubit(FirebaseAuth.instance),
      child: BlocConsumer<SignInCubit, SignInStates>(
        listener: (context,state){
          if(state is SignInSuccessState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in Successfully")));
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const NavigationBotBar()));
          }
          else if(state is SignInErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.em)));
        }
      },
          builder: (context, state){
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    },
                    child: Icon(Icons.add)),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/Logo.png",
                        width: MediaQuery.of(context).size.width*0.56,
                        color: Theme.of(context).colorScheme.primary,),
                      TextFormfieldWidget(hintText: "Email", controller: emailController,),
                      SizedBox(height: 21),
                      TextFormfieldWidget(hintText: "Password", controller: passController, obsecure: true),
                      SizedBox(height: 21),
                      InkWell(
                        onTap: () {
                          final email = emailController.text;
                          final pass = passController.text;
                          context.read<SignInCubit>().signIn(email, pass);
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 163, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white),
                              )),
                        ),
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
              );
          }
      ),
    );
  }
}
