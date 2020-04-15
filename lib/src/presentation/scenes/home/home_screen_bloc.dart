import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';
import 'package:xhabits/src/domain/remove_habit_use_case.dart';
import 'package:xhabits/src/domain/remove_habits_use_case.dart';
import 'package:xhabits/src/presentation/push_notifications_service.dart';
import 'package:xhabits/src/presentation/scenes/home/app_bar_state.dart';
import 'home_screen_state.dart';

class HomeScreenBloc {
  BehaviorSubject<bool> _logoutStateSubject;
  BehaviorSubject<HomeScreenResource> _homeStateSubject;
  BehaviorSubject<AppBarState> _appBarStateSubject;
  BehaviorSubject<bool> _habitDeletedSubject;
  BehaviorSubject<bool> _habitEditedSubject;
  Map<Habit, int> selectedHabits = <Habit, int>{};
  PushNotificationsService _notificationsService;

  Stream<HomeScreenResource> get homeScreenStateObservable =>
      _homeStateSubject.stream;

  Stream<bool> get logoutStateObservable => _logoutStateSubject.stream;

  Stream<AppBarState> get appBarStateObservable => _appBarStateSubject.stream;

  Stream<bool> get habitDeletedState => _habitDeletedSubject.stream;

  HomeScreenUseCase _useCase;
  LogoutUseCase _logoutUseCase;
  RemoveHabitUseCase _removeUseCase;
  RemoveHabitsUseCase _removeHabitsUseCase;

  HomeScreenBloc(
      HomeScreenUseCase useCase,
      LogoutUseCase logoutUseCase,
      RemoveHabitUseCase removeUseCase,
      RemoveHabitsUseCase removeHabitsUseCase,
      bool notificationOn,
      BuildContext context) {
    _useCase = useCase;
    if (notificationOn) {
      _notificationsService = PushNotificationsService(context);
    }
    _logoutUseCase = logoutUseCase;
    _removeUseCase = removeUseCase;
    _removeHabitsUseCase = removeHabitsUseCase;
    _homeStateSubject = BehaviorSubject<HomeScreenResource>();
    _logoutStateSubject = BehaviorSubject<bool>();
    _appBarStateSubject =
        BehaviorSubject<AppBarState>.seeded(AppBarState(false, null));
    _habitDeletedSubject = BehaviorSubject<bool>.seeded(false);
    _habitEditedSubject = BehaviorSubject<bool>.seeded(false);
  }

  void getHomeData() {
    _useCase.getHabits().listen(handleHomeData);
  }

  void handleHomeData(List<Habit> habits) {
    _homeStateSubject.sink.add(HomeScreenResource(
        habits, _useCase.weekDays(habits), _useCase.daysWords(), false));
  }

  void logout() {
    _logoutUseCase.logout().listen(onLogout);
    _notificationsService.cancelAllNotifications();
  }

  void onLogout(bool result) {
    _logoutStateSubject.sink.add(result);
  }

  void onEdit() {
    _habitEditedSubject.sink.add(true);
    selectedHabits.clear();
    getHomeData();
    showMainAppBar();
  }

  void toggleHabit(Habit selectedHabit, int index) {
    updateHabitSelectedList(selectedHabit, index);
    selectionChanged();
    if (selectedHabits.isNotEmpty) {
      _appBarStateSubject.sink.add(AppBarState(true, selectedHabit));
    } else {
      _appBarStateSubject.sink.add(AppBarState(false, null));
    }
  }

  void updateHabitSelectedList(Habit selectedHabit, int index) {
    if (!selectedHabits.containsKey(selectedHabit)) {
      selectedHabits[selectedHabit] = index;
    } else {
      selectedHabits.remove(selectedHabit);
    }
  }

  bool isHabitSelected(selectedHabit) =>
      selectedHabits.containsKey(selectedHabit);

  void removeHabit(String habitId) {
    _removeUseCase.removeHabit(habitId);
    _onRemove();
  }

  void removeHabits(List<String> habitIds) {
    _removeHabitsUseCase.removeHabits(habitIds);
    _onRemove();
  }

  void _onRemove() {
    _habitDeletedSubject.sink.add(true);
    _cancelDeletedNotifications();
    getHomeData();
    showMainAppBar();
  }

  bool rebuildHabitTile(Habit currentHabit) =>
      selectedHabits.containsKey(currentHabit) ||
      _habitDeletedSubject.stream.value ||
      _habitEditedSubject.stream.value;

  void showDailyNotification(int pushId, String title, TimeOfDay habitTime) {
    _notificationsService.showDailyNotification(pushId, title, habitTime);
  }

  void cancelNotification(int index) {
    _notificationsService.cancelNotification(index);
  }

  void _cancelDeletedNotifications() {
    selectedHabits.values.forEach(cancelNotification);
  }

  void showMainAppBar() {
    _appBarStateSubject.sink.add(AppBarState(false, null));
  }

  Future<bool> onWillPop() async {
    selectedHabits.clear();
    if (_appBarStateSubject.stream.value.showEditingAppBar) {
      showMainAppBar();
      return false;
    }
    return true;
  }

  void selectionChanged() {
    _habitDeletedSubject.sink.add(false);
    _habitEditedSubject.sink.add(false);
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
