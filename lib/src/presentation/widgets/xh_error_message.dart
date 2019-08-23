import 'package:flutter/material.dart';

class XHErrorMessage {
  final String message;

  XHErrorMessage(this.message);

  Widget messageError() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
