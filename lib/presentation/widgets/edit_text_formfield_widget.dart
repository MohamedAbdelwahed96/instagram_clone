import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTextFormfieldWidget extends StatefulWidget {
  final String name;
  final TextEditingController controller;
  final int maxLines;
  final bool lineEnabled, dropDown;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormats;

  const EditTextFormfieldWidget(
      {super.key,
        required this.name,
        required this.controller,
        this.maxLines = 1,
        this.lineEnabled = true,
        this.dropDown = false,
        this.keyboardType = TextInputType.text,
        this.inputFormats = const []});

  @override
  State<EditTextFormfieldWidget> createState() => _EditTextFormfieldWidgetState();
}

class _EditTextFormfieldWidgetState extends State<EditTextFormfieldWidget> {
  String? dropValue;

  @override
  void initState() {
    super.initState();
    dropValue = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width*.25, child: Text(widget.name)),
          Expanded(
              child: Column(
                children: [
                  widget.dropDown?FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            items: const [
                              DropdownMenuItem(value: "Male", child: Text("Male")),
                              DropdownMenuItem(value: "Female", child: Text("Female"))
                            ],
                            value: dropValue,
                            onChanged: (String? value) => setState(() {
                              dropValue=value;
                              widget.controller.text=value!;
                            }),
                          ),
                        ),
                      );
                    },
                  ) :
                  TextFormField(
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormats,
                    maxLines: widget.maxLines,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),),
                    ),
                  ),
                  widget.lineEnabled?Container(height: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.15)):SizedBox()
                ],
              )),
        ],
      ),
    );
  }
}
