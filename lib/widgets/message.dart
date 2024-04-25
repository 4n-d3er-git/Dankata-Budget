import 'package:flutter/material.dart';

// creat a custom snackbar
void message({required String message, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
  }
