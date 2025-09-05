import 'package:flutter/material.dart';

class MyTextbutton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const MyTextbutton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 20, color: Colors.black)),
    );
  }
}
