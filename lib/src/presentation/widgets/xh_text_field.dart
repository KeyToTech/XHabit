import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class XHTextField {
  final TextEditingController textController;
  final String hint;
  final bool obscureText;
  final FocusNode focusNode;
  final void Function(String) onFieldSubmitted;
  final TextInputType keyboardType;

  XHTextField(this.hint, this.textController,
      {this.keyboardType,
      this.obscureText,
      this.focusNode,
      this.onFieldSubmitted});

  Widget field() => TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
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
                fontFamily: 'Montserrat',
                fontSize: 10.0,
                color: XHColors.lightGrey)),
        obscureText: obscureText,
        controller: textController,
      );
}
