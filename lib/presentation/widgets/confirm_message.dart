import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context, String title, String message) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("no".tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("yes".tr()),
          ),
        ],
      );
    },
  );
}
