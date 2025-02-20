import 'package:flutter/material.dart';
import 'package:instagram_clone/logic/user_provider.dart';
import 'package:instagram_clone/presentation/widgets/button_widget.dart';
import 'package:instagram_clone/presentation/widgets/text_formfield_widget.dart';
import 'package:provider/provider.dart';

class SetEmailPhone extends StatefulWidget {
  @override
  _SetEmailPhoneState createState() => _SetEmailPhoneState();
}

class _SetEmailPhoneState extends State<SetEmailPhone> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context, listen: false).user!;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Add phone or email"),
            centerTitle: true,
            bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Theme.of(context).colorScheme.secondary.withOpacity(.5),
                tabs: [Tab(text: "PHONE"), Tab(text: "EMAIL")]),
          ),
          body: TabBarView(children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormfieldWidget(
                      hintText: "Phone", controller: phoneController),
                  SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        // user.phone = phoneController.text;
                      },
                      child: ButtonWidget(text: "Next"))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormfieldWidget(
                      hintText: "Email", controller: emailController),
                  SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        // user.email = emailController.text;
                      },
                      child: ButtonWidget(text: "Next"))
                ],
              ),
            )
          ]),
        ));
  }
}
