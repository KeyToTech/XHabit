import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/profile/profile_screen.dart';

class ProfileTabNavigator extends StatelessWidget {
  ProfileTabNavigator(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;
  bool notificationsStatus;

  @override
  Widget build(BuildContext context) => Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) => MaterialPageRoute(
          builder: (context) => ProfileScreen()));
}