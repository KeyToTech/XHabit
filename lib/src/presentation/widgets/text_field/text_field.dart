import 'package:flutter/material.dart';

class TextField extends StatefulWidget {
  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  final bool obscureText;
  final String label;

  _TextFieldState(this.obscureText, this.label);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      obscureText: obscureText,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
