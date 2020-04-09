import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/simple_check_user_is_signed_in_use_case.dart';
import 'package:xhabits/src/presentation/scenes/home/base_screen.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_screen.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';
import 'splash_screen_bloc.dart';
import 'splash_screen_state.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState(SplashScreenBloc(
      SimpleCheckUserIsSignedInUseCase(UserRepository(FirebaseAuthService()))));
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
    print('showHome: ${splashState.showHome}');
    StatefulWidget nextScreen;
    if (splashState.showHome == true && splashState.showLogin == false) {
      nextScreen = BaseScreen();
    } else {
      nextScreen = LoginScreen();
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.screenSize = MediaQuery.of(context).size;
    return Container(
        //alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'XHabit',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 65.0,
                decoration: TextDecoration.none,
                color: XHColors.pink,
              ),
            ),
            Text('BUILD  A  BETTER  YOU',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 23.5,
                    decoration: TextDecoration.none,
                    color: Colors.white))
          ],
        ),
      );
  }
}
