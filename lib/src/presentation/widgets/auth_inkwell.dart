import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class AuthInkWell {
  static Widget inkWell(
          BuildContext context, String inkText, StatefulWidget navigateTo) =>
      InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => navigateTo),
          );
        },
        child: Text(
          inkText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: XHColors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
