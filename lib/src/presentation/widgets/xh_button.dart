import 'package:flutter/material.dart';

class XHButton {
  final String text;
  final bool buttonEnabled;
  final void Function() submit;

  XHButton(this.text, this.buttonEnabled, this.submit);

  Widget materialButton() => Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        //shadowColor: buttonEnabled ? Color.fromRGBO(255, 51, 103, 1)
        //    : Color.fromRGBO(200, 200, 200, 1.0),
        elevation: 3.0,
        color: buttonEnabled ? Color.fromRGBO(255, 51, 103, 1)
            : Color.fromRGBO(200, 200, 200, 1.0),
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          minWidth: 400.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: buttonEnabled ? submit : null,
        ),
      ));
}
