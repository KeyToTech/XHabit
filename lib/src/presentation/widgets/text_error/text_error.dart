import 'package:flutter/material.dart';

class TextError extends StatefulWidget {
  TextError({Key key, this.message, this.isValid}) : super(key: key);

  final String message;
  final bool isValid;

  @override
  _TextErrorState createState() => _TextErrorState();
}

class _TextErrorState extends State<TextError> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Text(
       widget.isValid ? "" : widget.message,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
