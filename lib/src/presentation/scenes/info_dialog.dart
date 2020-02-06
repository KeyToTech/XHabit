import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class InfoDialog {
  void show(BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: XHColors.darkGrey,
        title: Text(title, style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            child: Text('Close', style: TextStyle(color: XHColors.pink)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
