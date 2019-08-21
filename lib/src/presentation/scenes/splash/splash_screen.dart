import 'package:flutter/material.dart';
import 'package:xhabits/src/data/mock/mock_user_repository.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';

import 'splash_screen_bloc.dart';
import 'splash_screen_state.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState(SplashScreenBloc(
      MockUserRepository()
  ));
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenBloc _splashBloc;

  _SplashScreenState(this._splashBloc);

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
