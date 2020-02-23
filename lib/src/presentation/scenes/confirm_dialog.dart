import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class ConfirmDialog {
  static void show(
    BuildContext context,
    String title,
    String message,
    VoidCallback confirmedAction,
    {VoidCallback canceledAction}
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel', style: TextStyle(color: XHColors.pink)),
            onPressed: () {
              if (canceledAction != null) {
                canceledAction();
              }
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Yes', style: TextStyle(color: XHColors.pink)),
            onPressed: (){
              confirmedAction();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
