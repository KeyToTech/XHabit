import 'package:flutter/material.dart';

class XHTextField {
  final TextEditingController textController;
  final String hint;
  final bool obscureText;

  XHTextField(this.hint, this.textController, this.obscureText);

  Widget field() => TextFormField(
        style: TextStyle(
          color: Color.fromRGBO(200, 200, 200, 1),
        ),
        decoration: InputDecoration(
            fillColor: Color.fromRGBO(64, 65, 70, 1),
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: hint,
            hintStyle: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 10.0,
                color: Color.fromRGBO(200, 200, 200, 1))),
        obscureText: obscureText,
        controller: textController,
      );
}
