import 'package:flutter/material.dart';
import 'package:xhabits/src/data/mock/mock_user_repository.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/scenes/login/login.dart';
import 'splash_screen_bloc.dart';
import 'splash_screen_state.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() =>
      _SplashScreenState(SplashScreenBloc(MockUserRepository()));
}

class _SplashScreenState extends State<SplashScreen> {
  final _splashBloc;

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
    StatefulWidget nextScreen;
    if (splashState.showHome == true && splashState.showLogin == false) {
      nextScreen = HomeScreen();
    } else {
      nextScreen = LoginScreen();
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextScreen));
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
