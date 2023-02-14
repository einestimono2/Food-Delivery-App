import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.title,
    this.hintText,
    this.controller,
    this.focusNode,
    this.textInputType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.border = true,
  });

  final String? title;
  final bool obscureText;
  final String? hintText;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool border;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = border
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            gapPadding: 8,
          )
        : UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          );

    return TextFormField(
      focusNode: focusNode,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: title,
        hintText: hintText,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
    );
  }
}
