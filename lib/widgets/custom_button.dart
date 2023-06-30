import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButon extends StatelessWidget {
  CustomButon({required this.color, required this.text, this.onPressed});
  String text;
  VoidCallback? onPressed;
  int color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Color(color), borderRadius: BorderRadius.circular(8)),
        width: 250,
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.black),
            )));
  }
}
