import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class XHButton {
  final String text;
  final bool buttonEnabled;
  final void Function() submit;

  XHButton(this.text, this.buttonEnabled, this.submit);

  Widget materialButton() => Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 3.0,
        color: buttonEnabled ? XHColors.pink
          : XHColors.lightGrey,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          minWidth: 700.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: buttonEnabled ? submit : null,
        ),
      ));
}
