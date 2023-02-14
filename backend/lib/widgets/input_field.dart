import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.title,
    this.controller,
    this.hintText,
    this.isTextArea = false,
    this.readOnly = false,
    this.spaceEnd = true,
    this.minLines = 4,
  });

  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final bool isTextArea;
  final bool readOnly;
  final int minLines;
  final bool spaceEnd;

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Text(
            title ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (title != null)
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType:
              isTextArea ? TextInputType.multiline : TextInputType.none,
          maxLines: isTextArea ? null : 1,
          minLines: isTextArea ? minLines : null,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            border: outlineInputBorder,
          ),
        ),
        if (spaceEnd)
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      ],
    );
  }
}
