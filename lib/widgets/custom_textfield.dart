import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      this.labeltext,
      this.prefix,
      this.onChanged,
      required this.obscureText});
  String? labeltext;
  Widget? prefix;
  Function(String)? onChanged;
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: obscureText,
        validator: (data) {
          if (data!.isEmpty) {
            return "Required field";
          }
          return null;
        },
        onChanged: onChanged,
        cursorColor: Colors.black.withOpacity(0.2),
        decoration: InputDecoration(
          labelText: labeltext,
          prefixIcon: prefix,
          labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
          floatingLabelStyle:
              const TextStyle(color: Colors.black, fontSize: 18),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 1.5)),
        ));
  }
}
