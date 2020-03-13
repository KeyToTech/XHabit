import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'scenes/auth/register/register_screen.dart';
import 'scenes/splash/splash_screen.dart';

class XHApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'XHab',
        theme: ThemeData(
          accentColor: XHColors.pink,
          primaryColor: XHColors.pink,
          cursorColor: XHColors.pink,
          textSelectionHandleColor: XHColors.pink,
          fontFamily: 'Montserrat',
          dialogTheme: DialogTheme(
            backgroundColor: XHColors.darkGrey,
            elevation: 0,
          ),
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            subhead: TextStyle(color: Colors.white),
          ),
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: XHColors.pink,
          ),
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          RegisterScreen.routeName: (BuildContext context) =>
              RegisterScreen(title: 'Sign Up')
        },
      );
}
