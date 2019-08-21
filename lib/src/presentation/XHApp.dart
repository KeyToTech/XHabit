import 'package:flutter/material.dart';
import 'scenes/splash/splashScreen.dart';
import 'scenes/login/login_screen.dart';

class XHApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'XHab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen());
}
