import 'package:flutter/material.dart';
import 'scenes/splash/splash_screen.dart';
import 'scenes/auth/login/login_screen.dart';
import 'scenes/auth/register/register_screen.dart';

class XHApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'XHab',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: <String, WidgetBuilder>{
          RegisterScreen.routeName: (BuildContext context) =>
              RegisterScreen(title: 'Sign Up'),
        },
      );
}
