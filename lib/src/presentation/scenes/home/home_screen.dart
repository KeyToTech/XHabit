import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/simple_home_screen_data_use_case.dart';
import 'package:xhabits/src/domain/simple_logout_use_case.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_screen.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_row.dart';
import 'package:xhabits/src/presentation/scenes/home/habit_screen_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState(HomeScreenBloc(
      SimpleHomeScreenUseCase(HomeRepository()),
      SimpleLogoutUseCase(FirebaseAuthService())));
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenBloc _homeScreenBloc;
  Size _screenSize;

  _HomeScreenState(this._homeScreenBloc);

  @override
  void initState() {
    _homeScreenBloc.init();
    _homeScreenBloc.logoutStateObservable.listen(_handleLogoutRedirect);
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: appBar(), body: body());

  PreferredSizeWidget appBar() => AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: _homeScreenBloc.logout,
          ),
        ],
      );

  Widget body() => Container(
      color: Colors.grey[300],
      child: StreamBuilder<HomeScreenResource>(
          stream: _homeScreenBloc.homeScreenStateObservable,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              _screenSize = MediaQuery.of(context).size;
              final List<DateTime> days = snapshot.data.weekDays;
              final Map<int, String> daysWords = snapshot.data.daysWords;

              return Column(children: <Widget>[
                Container(
                  height: _screenSize.height * 0.08,
                  padding: EdgeInsets.only(
                    left: _screenSize.width * 0.485,
                    right: _screenSize.width * 0.015,
                    top: _screenSize.height * 0.018,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: days.length,
                          itemBuilder: (context, index) => Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  daysWords[days[index].weekday],
                                  style: TextStyle(
                                      fontSize: _screenSize.width * 0.024),
                                ),
                                Text(
                                  days[index].day.toString(),
                                  style: TextStyle(
                                      fontSize: _screenSize.width * 0.033),
                                )
                              ],
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: _screenSize.width * 0.031),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _habitsList([HabitRow('0', days), HabitRow('1', days)]),
              ]);
            }
          }));

  Widget _habitsList(List<HabitRow> habits) => Expanded(
        child: ListView.builder(
          itemCount: habits.length,
          itemBuilder: (BuildContext context, int index) => habits[index],
        ),
      );

  void _handleLogoutRedirect(bool wasLoggedOut) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void dispose() {
    _homeScreenBloc.dispose();
    super.dispose();
  }
}
