import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/database_home_screen_data_use_case.dart';
import 'package:xhabits/src/domain/simple_logout_use_case.dart';
import 'package:xhabits/src/domain/simple_remove_habit_use_case.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_screen.dart';
import 'package:xhabits/src/presentation/scenes/create_habit/create_habit.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_row.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_state.dart';
import 'package:xhabits/src/presentation/scenes/home/app_bar_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState(HomeScreenBloc(
      DatabaseHomeScreenUseCase(HomeRepository(FirebaseDatabaseService())),
      SimpleLogoutUseCase(FirebaseAuthService()),
      SimpleRemoveHabitUseCase(FirebaseDatabaseService())));
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenBloc _homeScreenBloc;
  Size _screenSize;

  _HomeScreenState(this._homeScreenBloc);

  @override
  void initState() {
    _homeScreenBloc.getHomeData();
    _homeScreenBloc.logoutStateObservable.listen(_handleLogoutRedirect);
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<Map<HomeScreenResource, AppBarState>>(
        stream: Observable.combineLatest2(
            _homeScreenBloc.homeScreenStateObservable,
            _homeScreenBloc.appBarStateObservable,
            (first, second) =>
                {first as HomeScreenResource: second as AppBarState}),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          _screenSize = MediaQuery.of(context).size;
          final HomeScreenResource homeState = snapshot.data.keys.first;
          final AppBarState appBarState = snapshot.data.values.first;

          final List<Habit> habits = homeState.habits;
          final List<DateTime> weekDays = homeState.weekDays;
          final Map<int, String> daysWords = homeState.daysWords;

          final String selectedHabitId = appBarState.selectedHabitId;

          return Scaffold(
            appBar: appBarState.showEditingAppBar
                ? editingAppBar(appBarState.selectedHabitId)
                : mainAppBar(),
            body: body(habits, selectedHabitId, weekDays, daysWords),
          );
        },
      );

  PreferredSizeWidget mainAppBar() => AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateHabit()));
            },
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

  PreferredSizeWidget editingAppBar(String selectedHabitId) => AppBar(
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _homeScreenBloc.cancelEditing,
        ),
        title: Text('Edit / remove habit'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _homeScreenBloc.removeHabit(selectedHabitId);
            },
          ),
        ],
      );

  Widget body(List<Habit> habits, String selectedHabitId,
          List<DateTime> weekDays, Map<int, String> daysWords) =>
      Container(
          color: Colors.grey[300],
          child: Column(children: <Widget>[
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
                      itemCount: weekDays.length,
                      itemBuilder: (context, index) => Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              daysWords[weekDays[index].weekday],
                              style: TextStyle(
                                  fontSize: _screenSize.width * 0.024),
                            ),
                            Text(
                              weekDays[index].day.toString(),
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
            _habitsList(habits, selectedHabitId, weekDays),
          ]));

  Widget _habitsList(List<Habit> habits, String selectedHabitId,
          List<DateTime> weekDays) {
    print('selected $selectedHabitId');
    return Expanded(
        child: ListView.builder(
          itemCount: habits.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: HabitRow(
                habits[index].title,
                habits[index].checkedDays,
                habits[index].habitId == selectedHabitId ? true : false,
                weekDays),
            onLongPress: () {
              _homeScreenBloc.selectHabit(habits[index].habitId);
            },
          ),
        ),
      );
  }

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
