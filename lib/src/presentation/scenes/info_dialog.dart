import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class InfoDialog {
  void show(BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('$title'),
        content: Text('$message'),
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
