import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showScaffoldMSG(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg.tr(),
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      action: SnackBarAction(
        label: "dismiss".tr(),
        textColor: Theme.of(context).colorScheme.primary,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
      behavior: SnackBarBehavior.floating, // Optional: Floating style
    ),
  );
}
