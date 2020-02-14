import 'package:flutter/material.dart';

class XHStatefulButton {
  final String text;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool buttonEnabled;
  final Color activeColor;
  final Color inactiveColor;
  final void Function() submit;

  XHStatefulButton(this.text, this.fontSize, this.padding, this.buttonEnabled,
      this.activeColor, this.inactiveColor, this.submit);

  Widget statefulButton() => FlatButton(
        padding: padding,
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
