import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/data/real_week_days.dart';
import 'package:xhabits/src/domain/database_home_screen_data_use_case.dart';
import 'package:xhabits/src/domain/simple_logout_use_case.dart';
import 'package:xhabits/src/domain/simple_remove_habit_use_case.dart';
import 'package:xhabits/src/presentation/XHColors.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_screen.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_row.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_state.dart';
import 'package:xhabits/src/presentation/scenes/home/app_bar_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_bloc.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/save_habit.dart';
import 'package:xhabits/src/presentation/screen_type.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState(HomeScreenBloc(
      DatabaseHomeScreenUseCase(
          HomeRepository(AppConfig.database, RealWeekDays())),
      SimpleLogoutUseCase(FirebaseAuthService()),
      SimpleRemoveHabitUseCase(AppConfig.database)));
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
        stream: Rx.combineLatest2(
            _homeScreenBloc.homeScreenStateObservable,
            _homeScreenBloc.appBarStateObservable,
            (first, second) =>
                {first as HomeScreenResource: second as AppBarState}),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              color: XHColors.darkGrey,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(XHColors.pink),
                ),
              ),
            );
          }

          _screenSize = MediaQuery.of(context).size;
          ScreenType.screenWidth = _screenSize.width;
          final HomeScreenResource homeState = snapshot.data.keys.first;
          final AppBarState appBarState = snapshot.data.values.first;

          final List<Habit> habits = homeState.habits;
          final List<DateTime> weekDays = homeState.weekDays;
          final Map<int, String> daysWords = homeState.daysWords;

          final Habit selectedHabit = appBarState.selectedHabit;
          return Scaffold(
            appBar: appBarState.showEditingAppBar
                ? editingAppBar(appBarState.selectedHabit)
                : mainAppBar(),
            body: body(habits, selectedHabit, weekDays, daysWords),
          );
        },
      );

  PreferredSizeWidget mainAppBar() => AppBar(
        title: Text(
          'Habits',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: XHColors.darkGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: XHColors.pink),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaveHabit.create(),
                ),
              );
              _homeScreenBloc.getHomeData();
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: XHColors.pink),
            onPressed: _homeScreenBloc.logout,
          ),
        ],
      );

  PreferredSizeWidget editingAppBar(Habit selectedHabit) => AppBar(
        backgroundColor: XHColors.darkGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: XHColors.pink),
          onPressed: _homeScreenBloc.showMainAppBar,
        ),
        title: Text('Edit / remove habit'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: XHColors.pink),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaveHabit.update(selectedHabit),
                ),
              );
              _homeScreenBloc.getHomeData();
              _homeScreenBloc.showMainAppBar();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: XHColors.pink),
            onPressed: () {
              _homeScreenBloc.removeHabit(selectedHabit.habitId);
            },
          ),
        ],
      );

  Widget body(List<Habit> habits, Habit selectedHabit, List<DateTime> weekDays,
          Map<int, String> daysWords) =>
      Container(
          color: XHColors.darkGrey,
          child: Column(children: <Widget>[
            Container(
              height: _screenSize.shortestSide * 0.09,
              width: _screenSize.width * 0.5,
              margin: EdgeInsets.only(
                left: _screenSize.width * 0.485,
                right: _screenSize.width * 0.015,
                top: _screenSize.height * 0.018,
              ),
              padding: EdgeInsets.only(
                  left: ScreenType.large
                      ? _screenSize.width * 0.112
                      : ScreenType.medium
                          ? _screenSize.width * 0.032
                          : 0),
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
                                fontSize: _screenSize.shortestSide * 0.024,
                                color: XHColors.lightGrey,
                              ),
                            ),
                            Text(
                              weekDays[index].day.toString(),
                              style: TextStyle(
                                fontSize: _screenSize.shortestSide * 0.033,
                                color: XHColors.lightGrey,
                              ),
                            )
                          ],
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenType.medium
                              ? _screenSize.width * 0.025
                              : _screenSize.width * 0.0235,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _habitsList(habits, selectedHabit, weekDays),
          ]));

  Widget _habitsList(
          List<Habit> habits, Habit selectedHabit, List<DateTime> weekDays) =>
      Expanded(
        child: ListView.builder(
          itemCount: habits.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: Container(
              margin: EdgeInsets.only(bottom: _screenSize.height * 0.005),
              decoration: _habitRowDecoration(habits[index], selectedHabit),
              child: HabitRow(
                habits[index].habitId,
                habits[index].title,
                habits[index].checkedDays,
                habits[index].startDate,
                habits[index].endDate,
                weekDays,
                key: habits[index].habitId ==
                        _homeScreenBloc.lastSelectedHabit?.habitId
                    ? UniqueKey()
                    : ValueKey(index),
              ),
            ),
            onLongPress: () {
              _homeScreenBloc.selectHabit(habits[index]);
              _homeScreenBloc.changeLastSelected(habits[index]);
            },
          ),
        ),
      );

  void _handleLogoutRedirect(bool wasLoggedOut) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  BoxDecoration _habitRowDecoration(Habit currentHabit, Habit selectedHabit) =>
      BoxDecoration(
        border: currentHabit.habitId == selectedHabit?.habitId
            ? Border(
                top: BorderSide(
                    color: XHColors.lightGrey,
                    width: _screenSize.shortestSide * 0.003),
                bottom: BorderSide(
                    color: XHColors.lightGrey,
                    width: _screenSize.shortestSide * 0.003),
              )
            : null,
      );

  @override
  void dispose() {
    _homeScreenBloc.dispose();
    super.dispose();
  }
}
