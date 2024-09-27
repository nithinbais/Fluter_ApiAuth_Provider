import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword, // For password fields
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
