import 'package:flutter/material.dart';

class XHTextField {
  final TextEditingController textController;
  final String hint;
  final bool obscureText;

  XHTextField(this.hint, this.textController, this.obscureText);

  Widget field() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: hint, border: OutlineInputBorder()),
      obscureText: obscureText,
      controller: textController,
    );
  }
}
