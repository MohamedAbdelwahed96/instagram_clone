import 'package:flutter/material.dart';

class FormControllers {
  final name = TextEditingController();
  final username = TextEditingController();
  final website = TextEditingController();
  final bio = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final gender = TextEditingController();

  void dispose() {
    name.dispose();
    username.dispose();
    website.dispose();
    bio.dispose();
    email.dispose();
    phone.dispose();
    gender.dispose();
  }
}
