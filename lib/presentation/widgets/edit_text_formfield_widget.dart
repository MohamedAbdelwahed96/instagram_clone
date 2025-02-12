import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTextFormfieldWidget extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final int maxLines;
  final bool lineEnabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormats;

  const EditTextFormfieldWidget(
      {super.key,
      required this.name,
      required this.controller,
      this.maxLines = 1,
      this.lineEnabled = true,
      this.keyboardType = TextInputType.text,
      this.inputFormats=const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width*.25, child: Text(name)),
          Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormats,
                    maxLines: maxLines,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),),
                    ),
                  ),
                  lineEnabled?Container(height: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.15)):SizedBox()
                ],
              )),
        ],
      ),
    );
  }
}
