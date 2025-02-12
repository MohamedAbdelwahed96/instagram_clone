import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final bool isEnabled;
  const ButtonWidget({super.key, required this.text, this.isEnabled=true});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.06,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: widget.isEnabled?Color.fromRGBO(0, 163, 255, 1):Color.fromRGBO(0, 163, 255, 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: Text(widget.text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: widget.isEnabled?Colors.white:Color.fromRGBO(255, 255, 255, 0.5)),
          )),
    );
  }
}
