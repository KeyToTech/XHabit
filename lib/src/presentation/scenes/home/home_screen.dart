import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/api/firebase/auth/firebase_auth_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/data/real_week_days.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/database_home_screen_data_use_case.dart';
import 'package:xhabits/src/domain/simple_logout_use_case.dart';
import 'package:xhabits/src/domain/simple_remove_habit_use_case.dart';
import 'package:xhabits/src/domain/simple_remove_habits_use_case.dart';
import 'package:xhabits/src/presentation/scenes/confirm_dialog.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_screen.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_row.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_state.dart';
import 'package:xhabits/src/presentation/scenes/home/app_bar_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_bloc.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/save_habit.dart';
import 'package:xhabits/src/presentation/styles/screen_type.dart';
import 'package:xhabits/src/presentation/scenes/message_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState(
        DatabaseHomeScreenUseCase(
            HomeRepository(AppConfig.database, RealWeekDays())),
        SimpleLogoutUseCase(UserRepository(FirebaseAuthService())),
        SimpleRemoveHabitUseCase(AppConfig.database),
        SimpleRemoveHabitsUseCase(AppConfig.database),
      );
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenBloc _homeScreenBloc;
  Size _screenSize;
  TrackingScrollController _dateScroll;
  TrackingScrollController _habitScroll;
  RefreshController _refreshController;

  _HomeScreenState(
      DatabaseHomeScreenUseCase databaseUseCase,
      SimpleLogoutUseCase logoutUseCase,
      SimpleRemoveHabitUseCase removeHabitUseCase,
      SimpleRemoveHabitsUseCase removeHabitsUseCase) {
    _homeScreenBloc = HomeScreenBloc(databaseUseCase, logoutUseCase,
        removeHabitUseCase, removeHabitsUseCase, !kIsWeb, context);
  }

  @override
  void initState() {
    _homeScreenBloc.getHomeData();
    _homeScreenBloc.logoutStateObservable.listen(_handleLogoutRedirect);
    _dateScroll = TrackingScrollController();
    _habitScroll = TrackingScrollController();
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: Rx.combineLatest3(
            _homeScreenBloc.homeScreenStateObservable,
            _homeScreenBloc.appBarStateObservable,
            _homeScreenBloc.habitDeletedState,
            (first, second, third) => [first, second, third]),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              color: XHColors.darkGrey,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          _screenSize = MediaQuery.of(context).size;
          ScreenType.screenWidth = _screenSize.width;
          final HomeScreenResource homeState =
              snapshot.data[0] as HomeScreenResource;
          final AppBarState appBarState = snapshot.data[1] as AppBarState;
          final bool habitDeleted = snapshot.data[2] as bool;

          final List<Habit> habits = homeState.habits;
          final List<DateTime> weekDays = homeState.weekDays;
          final Map<int, String> daysWords = homeState.daysWords;

          final Habit selectedHabit = appBarState.selectedHabit;
          return Scaffold(
            appBar: appBarState.showEditingAppBar
                ? editingAppBar(_homeScreenBloc.selectedHabits.first, habits)
                : mainAppBar(),
            body:
                body(habits, selectedHabit, weekDays, daysWords, habitDeleted),
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
          MaterialButton(
            child: Icon(Icons.add, color: XHColors.pink),
            onPressed: () async {
              await onHabitAdd();
              _homeScreenBloc.getHomeData();
            },
            shape: CircleBorder(),
            minWidth: 0,
          ),
          MaterialButton(
            child: Icon(Icons.exit_to_app, color: XHColors.pink),
            onPressed: () {
              ConfirmDialog.show(
                context,
                'Logout',
                'Are you sure you want to logout?',
                _homeScreenBloc.logout,
              );
            },
            shape: CircleBorder(),
            minWidth: 0,
          ),
        ],
      );

  Widget editHabitButton(Habit selectedHabit){
    Widget editButton;
    if(_homeScreenBloc.selectedHabits.length == 1){
      editButton = MaterialButton(
        child: Icon(Icons.edit, color: XHColors.pink),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveHabit.update(selectedHabit),
            ),
          );
          _homeScreenBloc.onEdit();
          _homeScreenBloc.selectedHabits.clear();
          _homeScreenBloc.getHomeData();
          _homeScreenBloc.showMainAppBar();
        },
        shape: CircleBorder(),
        minWidth: 0,
      );
    }
    else {
      editButton = SizedBox(width: _screenSize.width * 0.11);
    }
    return editButton;
  }

  PreferredSizeWidget editingAppBar(Habit selectedHabit, List<Habit> habits) =>
      AppBar(
        backgroundColor: XHColors.darkGrey,
        leading: MaterialButton(
          child: Icon(Icons.arrow_back, color: XHColors.pink),
          onPressed: () {
            _homeScreenBloc.showMainAppBar();
            _homeScreenBloc.selectedHabits.clear();
          },
          shape: CircleBorder(),
          minWidth: 0,
        ),
        title: Text('Edit / remove habit'),
        actions: <Widget>[
          editHabitButton(selectedHabit),
          MaterialButton(
            child: Icon(Icons.delete, color: XHColors.pink),
            onPressed: () {
              if (_homeScreenBloc.selectedHabits.length == 1) {
                ConfirmDialog.show(
                  context,
                  'Delete habit',
                  'Are you sure you want to delete habit \'${selectedHabit.title}\' ?',
                  () => _homeScreenBloc.removeHabit(selectedHabit.habitId),
                );
                _homeScreenBloc.selectedHabits.clear();
              } else {
                List<String> habitIds = _homeScreenBloc.selectedHabits
                    .map((f) => f.habitId)
                    .toList();
                ConfirmDialog.show(
                    context,
                    'Delete habits',
                    'Are you sure you want to delete these habits?',
                    () => _homeScreenBloc.removeHabits(habitIds));
                _homeScreenBloc.selectedHabits.clear();
              }
            },
            shape: CircleBorder(),
            minWidth: 0,
          ),
        ],
      );

  Widget body(List<Habit> habits, Habit selectedHabit, List<DateTime> weekDays,
      Map<int, String> daysWords, bool habitDeleted) {
    if (habits.isNotEmpty) {
      return WillPopScope(
        onWillPop: _homeScreenBloc.onWillPop,
        child: Container(
            color: XHColors.darkGrey,
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
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
                          : ScreenType.medium ? _screenSize.width * 0.032 : 0),
                  child: ListView.builder(
                    controller: _dateScroll,
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    itemCount: weekDays.length,
                    itemBuilder: (context, index) => Container(
                      child: SizedBox(
                        width: ScreenType.medium
                            ? _screenSize.width * 0.032
                            : _screenSize.width * 0.06,
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
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: _screenSize.width * 0.02,
                      ),
                    ),
                  ),
                ),
                _habitsList(habits, selectedHabit, weekDays, habitDeleted),
              ]),
            )),
      );
    } else {
      _homeScreenBloc.getHomeData();
      return Container(
          color: XHColors.darkGrey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You don\'t have any habits yet.',
                  style: TextStyle(color: XHColors.lightGrey, fontSize: 20.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _startAddingHabit(),
                    Text(
                      'adding a new habit!',
                      style: TextStyle(fontSize: 20, color: XHColors.lightGrey),
                    )
                  ],
                )
              ]));
    }
  }

  Widget _habitsList(List<Habit> habits, Habit selectedHabit,
          List<DateTime> weekDays, bool habitDeleted) =>
      Expanded(
        child: SmartRefresher(
          controller: _refreshController,
          header: MaterialClassicHeader(),
          onRefresh: () {
            _homeScreenBloc.getHomeData();
            _refreshController.refreshCompleted();
          },
          child: ListView.builder(
            itemCount: habits.length,
            itemBuilder: (BuildContext context, int index) {
              if (!kIsWeb) {
                if (habits[index].notificationTime != null) {
                  _homeScreenBloc.showDailyNotification(
                    index,
                    habits[index].title,
                    _homeScreenBloc
                        .parseTimeString(habits[index].notificationTime),
                  );
                } else {
                  _homeScreenBloc.cancelNotification(index);
                }
              }
              return Container(
                decoration: _habitRowDecoration(habits[index]),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  title: HabitRow(
                    habits[index].habitId,
                    habits[index].title,
                    habits[index].checkedDays,
                    habits[index].startDate,
                    _homeScreenBloc.isHabitSelected(habits[index]),
                    weekDays,
                    key: _homeScreenBloc.rebuildHabitTile(habits[index])
                        ? UniqueKey()
                        : ValueKey(index),
                    endDate: habits[index].endDate,
                    scrollController: _habitScroll,
                  ),
                  onLongPress: () {
                    _homeScreenBloc.toggleHabit(habits[index]);
                  },
                  onTap: (){
                    if(_homeScreenBloc.selectedHabits.isNotEmpty){
                      _homeScreenBloc.toggleHabit(habits[index]);
                    }
                  },
                ),
              );
            },
          ),
        ),
      );
  
  Future<void> onHabitAdd() async {
    bool habitSaved = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SaveHabit.create()),
    ) ??
        false;
    if (habitSaved) {
      MessageDialog.show(context, "New habit created!",
          "Your new habit has been created!");
      _homeScreenBloc.selectedHabits.clear();
    }
  }
  
  bool _onScrollNotification(ScrollNotification scrollInfo) {
    double jumpTo = _dateScroll.offset - 0.0001;
    _habitScroll.jumpTo(jumpTo > 0 ? jumpTo : _dateScroll.offset);
    return true;
  }

  void _handleLogoutRedirect(bool wasLoggedOut) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Widget _startAddingHabit() => Row(children: <Widget>[
        InkWell(
          onTap: onHabitAdd,
          child: Text('Start ',
              style: TextStyle(
                  color: XHColors.pink,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
        )
      ]);

  BoxDecoration _habitRowDecoration(Habit selectedHabit) =>
      BoxDecoration(
        border: _homeScreenBloc.isHabitSelected(selectedHabit)
            ? Border.symmetric(
                vertical: BorderSide(
                  color: XHColors.lightGrey,
                  width: _screenSize.shortestSide * 0.003,
                ),
              )
            : Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: _screenSize.shortestSide * 0.0015,
                ),
              ),
      );

  @override
  void dispose() {
    _homeScreenBloc.dispose();
    super.dispose();
  }
}
