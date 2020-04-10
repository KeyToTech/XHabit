import 'package:flutter/material.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/save_habit.dart';
import '../home_screen.dart';

class HomeTabNavigatorRoutes {
  static const String root = '/';
  static const String save = '/save';
}

class HomeTabNavigator extends StatelessWidget {
  HomeTabNavigator(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;

  void _push(BuildContext context, Habit habit) {
    var routeBuilders = _routeBuilders(context, habit);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[HomeTabNavigatorRoutes.save](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, Habit habit) => {
    HomeTabNavigatorRoutes.root: (context) => HomeScreen((Habit habit) {
        _push(context, habit);
      }),
    HomeTabNavigatorRoutes.save: (context) => habit == null ? SaveHabit.create() : SaveHabit.update(habit)
    };

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context, null);

    return Navigator(
        key: navigatorKey,
        initialRoute: HomeTabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) => MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context)));
  }
}