import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_screen.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class AuthInkWell {
  static Widget inkWell(BuildContext context, String inkText,
          {bool navigateToRegister}) =>
      InkWell(
        onTap: () {
          if (navigateToRegister) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          } else {
            Navigator.of(context).pop();
          }
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
