import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';
import 'splashScreenBloc.dart';
import 'splashScreenState.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _splashBloc = SplashScreenBloc();

  @override
  void initState() {
    super.initState();
    _splashBloc.loadSplash();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<SplashScreenState>(
        stream: _splashBloc.splashStateObservable,
        builder:
            (BuildContext context, AsyncSnapshot<SplashScreenState> snapshot) {
          final splashState = snapshot.data;

          void handleTimeout() {
            if(splashState.showHome == true && splashState.showLogin == false) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
            else {
              // LoginScreen
            }
          }

          void Timeout() async {
            Duration duration = Duration(seconds: 3);
            Timer(duration, handleTimeout);
          }

          Timeout();
          return buildUi(context);
        },
      );

  Widget buildUi(BuildContext context) => Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Text(
          'XHabit',
          style: TextStyle(
            fontSize: 36.0,
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
        ),
      );
}
