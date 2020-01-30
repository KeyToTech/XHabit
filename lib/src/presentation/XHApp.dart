import 'package:flutter/material.dart';
import 'scenes/auth/register/register_screen.dart';
import 'scenes/splash/splash_screen.dart';

class XHApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'XHab',
        theme:
            ThemeData(primaryColor: Color.fromRGBO(255, 51, 103, 1),
                cursorColor: Color.fromRGBO(255, 51, 103, 1),
                fontFamily: 'Montserrat'),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          RegisterScreen.routeName: (BuildContext context) =>
              RegisterScreen(title: 'Sign Up')
        },
      );
}
