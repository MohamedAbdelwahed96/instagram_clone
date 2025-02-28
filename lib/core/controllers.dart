import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FormControllers {
  final name = TextEditingController();
  final username = TextEditingController();
  final website = TextEditingController();
  final bio = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final gender = TextEditingController();
  final search = TextEditingController();
  final message = TextEditingController();
  final page = PageController(initialPage: 0);
  final caption = TextEditingController();

  void dispose() {
    name.dispose();
    username.dispose();
    website.dispose();
    bio.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    gender.dispose();
    search.dispose();
    message.dispose();
    page.dispose();
    caption.dispose();
  }
}
