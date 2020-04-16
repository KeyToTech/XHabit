import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';
import 'package:xhabits/src/domain/remove_habit_use_case.dart';
import 'package:xhabits/src/domain/remove_habits_use_case.dart';
import 'package:xhabits/src/presentation/push_notifications_service.dart';
import 'package:xhabits/src/presentation/scenes/home/app_bar_state.dart';
import 'home_screen_state.dart';

class HomeScreenBloc {
  bool globalNotificationsStatus;
  BehaviorSubject<HomeScreenResource> _homeStateSubject;
  BehaviorSubject<AppBarState> _appBarStateSubject;
  BehaviorSubject<bool> _habitDeletedSubject;
  BehaviorSubject<bool> _habitEditedSubject;
  BehaviorSubject<bool> _notificationsSwitchedSubject;
  Map<Habit, int> selectedHabits = <Habit, int>{};
  PushNotificationsService _notificationsService;

  Stream<HomeScreenResource> get homeScreenStateObservable =>
      _homeStateSubject.stream;

  Stream<AppBarState> get appBarStateObservable => _appBarStateSubject.stream;

  Stream<bool> get habitDeletedState => _habitDeletedSubject.stream;
  Stream<bool> get notificationsSwitchedObservable => _notificationsSwitchedSubject.stream;

  HomeScreenUseCase _useCase;
  RemoveHabitUseCase _removeUseCase;
  RemoveHabitsUseCase _removeHabitsUseCase;
  GlobalNotificationsUpdateUseCase _globalNotificationsUpdateUseCase;

  HomeScreenBloc(
      HomeScreenUseCase useCase,
      RemoveHabitUseCase removeUseCase,
      RemoveHabitsUseCase removeHabitsUseCase,
      GlobalNotificationsUpdateUseCase globalNotificationsUpdateUseCase,
      bool notificationOn,
      BuildContext context) {
    globalNotificationsStatus = true;
    _useCase = useCase;
    if (notificationOn) {
      _notificationsService = PushNotificationsService(context);
    }
    _globalNotificationsUpdateUseCase = globalNotificationsUpdateUseCase;
    _removeUseCase = removeUseCase;
    _removeHabitsUseCase = removeHabitsUseCase;
    _homeStateSubject = BehaviorSubject<HomeScreenResource>();
    _appBarStateSubject =
        BehaviorSubject<AppBarState>.seeded(AppBarState(false, null));
    _habitDeletedSubject = BehaviorSubject<bool>.seeded(false);
    _habitEditedSubject = BehaviorSubject<bool>.seeded(false);
    _notificationsSwitchedSubject = BehaviorSubject<bool>.seeded(false);
    getGlobalNotificationStatus();
  }

  void getHomeData() {
    _useCase.getHabits().listen(handleHomeData);
  }

  void getGlobalNotificationStatus() {
    _globalNotificationsUpdateUseCase
        .getGlobalNotificationsStatus()
        .listen(handleGlobalNotificationsData);
  }

  void handleGlobalNotificationsData(bool status) {
    globalNotificationsStatus = status;
    notificationsSwitched();
  }

  void handleHomeData(List<Habit> habits) {
    _homeStateSubject.sink.add(HomeScreenResource(
        habits, _useCase.weekDays(habits), _useCase.daysWords(), false));
  }

  void cancelAllNotification() {
    _notificationsService.cancelAllNotifications();
  }

  void onEdit() {
    _habitEditedSubject.sink.add(true);
    selectedHabits.clear();
    getHomeData();
    showMainAppBar();
  }

  void notificationsSwitched(){
    _notificationsSwitchedSubject.sink.add(globalNotificationsStatus);
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

  void showNotifications(int index, List<Habit> habits) {
    if (!kIsWeb && !_habitDeletedSubject.value) {
      if (globalNotificationsStatus) {
        trySendNotification(index, habits);
      } else {
        cancelAllNotification();
      }
    }
  }

  void trySendNotification(int index, List<Habit> habits) {
    if (habits[index].notificationTime != null) {
      showDailyNotification(
        index,
        habits[index].title,
        parseTimeString(habits[index].notificationTime),
      );
    } else {
      cancelNotification(index);
    }
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
  }
}
