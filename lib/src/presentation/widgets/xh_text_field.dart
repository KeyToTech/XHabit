import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/XHColors.dart';

class XHTextField {
  final TextEditingController textController;
  final String hint;
  final bool obscureText;

  XHTextField(this.hint, this.textController, this.obscureText);

  Widget field() => TextFormField(
    style: TextStyle(
      color: XHColors.lightGrey,
    ),
    decoration: InputDecoration(
        fillColor: XHColors.grey,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: hint,
        hintStyle: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 10.0,
            color: XHColors.lightGrey)),
    obscureText: obscureText,
    controller: textController,
    );
}
