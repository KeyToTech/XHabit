import 'package:flutter/material.dart';
import '../home_screen.dart';

class HomeTabNavigator extends StatelessWidget {
  HomeTabNavigator(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSettings) => MaterialPageRoute(
              builder: (context) => HomeScreen()));
}