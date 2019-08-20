import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';

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
    _splashBloc.splashStateObservable
        .delay(Duration(seconds: 3))
        .listen(handleTimeout);
    _splashBloc.loadSplash();
  }

  @override
  void dispose() {
    _splashBloc.closeStream;
    super.dispose();
  }

  void handleTimeout(SplashScreenState splashState) {
    print('handleTimeout: ${splashState.showHome}');
    if (splashState.showHome == true && splashState.showLogin == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // LoginScreen
      //TODO implement navigation to Login screen https://trello.com/c/ZmIQoZ0A/38-navigation-to-login-from-splash
    }
  }

  @override
  Widget build(BuildContext context) => Container(
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
