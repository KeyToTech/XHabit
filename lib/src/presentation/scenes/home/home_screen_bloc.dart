import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';
import 'package:xhabits/src/domain/remove_habit_use_case.dart';
import 'package:xhabits/src/presentation/push_notifications_service.dart';
import 'package:xhabits/src/presentation/scenes/home/app_bar_state.dart';

import 'home_screen_state.dart';

class HomeScreenBloc {
  BehaviorSubject<bool> _logoutStateSubject;
  BehaviorSubject<HomeScreenResource> _homeStateSubject;
  BehaviorSubject<AppBarState> _appBarStateSubject;
  BehaviorSubject<bool> _habitDeletedSubject;
  Habit lastSelectedHabit;
  PushNotificationsService _notificationsService;

  Stream<HomeScreenResource> get homeScreenStateObservable =>
      _homeStateSubject.stream;

  Stream<bool> get logoutStateObservable => _logoutStateSubject.stream;

  Stream<AppBarState> get appBarStateObservable => _appBarStateSubject.stream;

  Stream<bool> get habitDeletedState => _habitDeletedSubject.stream;

  HomeScreenUseCase _useCase;
  LogoutUseCase _logoutUseCase;
  RemoveHabitUseCase _removeUseCase;

  HomeScreenBloc(
      HomeScreenUseCase useCase,
      LogoutUseCase logoutUseCase,
      RemoveHabitUseCase removeUseCase,
      bool notificationOn,
      BuildContext context) {
    _useCase = useCase;
    if (notificationOn) {
      _notificationsService = PushNotificationsService(context);
    }
    _logoutUseCase = logoutUseCase;
    _removeUseCase = removeUseCase;
    _homeStateSubject = BehaviorSubject<HomeScreenResource>();
    _logoutStateSubject = BehaviorSubject<bool>();
    _appBarStateSubject =
        BehaviorSubject<AppBarState>.seeded(AppBarState(false, null));
    _habitDeletedSubject = BehaviorSubject<bool>.seeded(false);
  }

  void getHomeData() {
    _useCase.getHabits().listen(handleHomeData);
  }

  void handleHomeData(List<Habit> habits) {
    _homeStateSubject.sink.add(HomeScreenResource(
        habits, _useCase.weekDays(), _useCase.daysWords(), false));
  }

  void logout() {
    _logoutUseCase.logout().listen(onLogout);
    _notificationsService.cancelAllNotifications();
  }

  void onLogout(bool result) {
    _logoutStateSubject.sink.add(result);
  }

  void selectHabit(Habit selectedHabit) {
    _appBarStateSubject.sink.add(AppBarState(true, selectedHabit));
  }

  void removeHabit(String habitId) {
    _removeUseCase.removeHabit(habitId);
    _habitDeletedSubject.sink.add(true);
    getHomeData();
    showMainAppBar();
  }

  bool rebuildHabitTile(Habit currentHabit) =>
      currentHabit.habitId == lastSelectedHabit?.habitId ||
      _habitDeletedSubject.stream.value;

  void showDailyNotification(int pushId, String title, TimeOfDay habitTime) {
    _notificationsService.showDailyNotification(pushId, title, habitTime);
  }

  void cancelNotification(int index) {
    _notificationsService.cancelNotification(index);
  }

  void showMainAppBar() {
    _appBarStateSubject.sink.add(AppBarState(false, null));
  }

  void changeLastSelected(Habit selectedHabit) {
    _habitDeletedSubject.sink.add(false);
    if (selectedHabit != null) {
      lastSelectedHabit = selectedHabit;
    }
  }

  TimeOfDay parseTimeString(String timeString) {
    var hour = int.parse(timeString.split(':')[0]);
    var minute = int.parse(timeString.split(':')[1]);
    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }

  void dispose() {
    _homeStateSubject.close();
    _logoutStateSubject.close();
  }
}
