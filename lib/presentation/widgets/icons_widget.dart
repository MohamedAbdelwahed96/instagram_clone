import 'package:flutter/material.dart';

class IconsWidget extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  const IconsWidget({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 24,
        width: 24,
        child: Image.asset("assets/icons/$icon.png",
        color: Theme.of(context).colorScheme.primary)
      ),
    );
  }
}
