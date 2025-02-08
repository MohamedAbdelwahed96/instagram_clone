import 'package:flutter/material.dart';

class TextFormfieldWidget extends StatelessWidget {
  final bool obsecure;
  final String hintText;
  final TextEditingController controller;

  const TextFormfieldWidget({super.key, this.obsecure=false,required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      obscureText: obsecure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.inversePrimary,
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.secondary),

        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
