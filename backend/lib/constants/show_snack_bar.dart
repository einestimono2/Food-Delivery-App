import 'package:flutter/material.dart';

// Show snackBar
void showSnackBar(
  BuildContext context,
  String text, {
  Color? backgroundColor,
}) =>
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor ?? Colors.black,
          duration: const Duration(seconds: 2),
          width: MediaQuery.of(context).size.width * 0.8,
          content: Text(text, textAlign: TextAlign.justify),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        ),
      );
