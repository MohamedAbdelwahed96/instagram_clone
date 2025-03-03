import 'package:flutter/material.dart';

class IconsWidget extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  const IconsWidget({super.key, required this.icon, this.onTap, this.size=24, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: size,
        width: size,
        child: Image.asset("assets/icons/$icon.png",
        color: color ?? Theme.of(context).colorScheme.primary)
      ),
    );
  }
}
