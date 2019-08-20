import 'package:flutter/material.dart';
import 'package:xhabits/presentation/login/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XHabit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginUi(
        title: "Login",
      ),
    );
  }
}
