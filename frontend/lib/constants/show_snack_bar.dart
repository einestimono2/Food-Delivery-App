import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          width: MediaQuery.of(context).size.width * 95 / 100,
          content: Text(text, textAlign: TextAlign.justify),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      );
