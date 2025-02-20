import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';

class FloatingButtonWidget extends StatefulWidget {
  const FloatingButtonWidget({super.key});

  @override
  State<FloatingButtonWidget> createState() => _FloatingButtonWidgetState();
}

class _FloatingButtonWidgetState extends State<FloatingButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: (){
      showDialog(context: context, builder: (context){
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    onTap: ()=> context.setLocale(Locale("en")),
                    leading: Text("EN"),
                    title: Text("English"),
                  ),
                  ListTile(
                    onTap: ()=> context.setLocale(Locale("ar")),
                    leading: Text("AR"),
                    title: Text("Arabic"),
                  ),
                  ListTile(
                    onTap: ()=> Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                    leading: Text("Theme"),
                    title: Text("Change theme"),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
      // backgroundColor: Colors.white,
      child: Icon(Icons.language,
        // color: Colors.black
      ),
    );
  }
}
