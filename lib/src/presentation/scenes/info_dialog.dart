import 'package:flutter/material.dart';

class InfoDialog {

  void show(BuildContext context, String title, String message) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) =>
        // return object of type Dialog
        AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}