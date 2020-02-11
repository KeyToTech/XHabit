import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/XHColors.dart';

class XHStatefulButton {
  final String text;
  final double fontSize;
  final bool buttonEnabled;
  final Color activeColor;
  final Color inactiveColor;
  final void Function() submit;

  XHStatefulButton(this.text, this.fontSize, this.buttonEnabled,
      this.activeColor, this.inactiveColor, this.submit);


  Widget statefulButton() => FlatButton(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: buttonEnabled ? activeColor : inactiveColor,
        ),
      ),
      onPressed: buttonEnabled ? submit : null,
  );
}
