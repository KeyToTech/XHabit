import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';
import 'package:xhabits/src/domain/remove_habit_use_case.dart';
import 'package:xhabits/src/presentation/scenes/home/app_bar_state.dart';

import 'home_screen_state.dart';

class HomeScreenBloc {
  BehaviorSubject<bool> _logoutStateSubject;
  BehaviorSubject<HomeScreenResource> _homeStateSubject;
  BehaviorSubject<AppBarState> _appBarStateSubject;

  Stream<HomeScreenResource> get homeScreenStateObservable =>
      _homeStateSubject.stream;

  Stream<bool> get logoutStateObservable => _logoutStateSubject.stream;

  Stream<AppBarState> get appBarStateObservable => _appBarStateSubject.stream;

  HomeScreenUseCase _useCase;
  LogoutUseCase _logoutUseCase;
  RemoveHabitUseCase _removeUseCase;

  HomeScreenBloc(HomeScreenUseCase useCase, LogoutUseCase logoutUseCase,
      RemoveHabitUseCase removeUseCase) {
    _useCase = useCase;
    _logoutUseCase = logoutUseCase;
    _removeUseCase = removeUseCase;
    _homeStateSubject = BehaviorSubject<HomeScreenResource>();
    _logoutStateSubject = BehaviorSubject<bool>();
    _appBarStateSubject =
        BehaviorSubject<AppBarState>.seeded(AppBarState(false, null));
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
  }

  void onLogout(bool result) {
    _logoutStateSubject.sink.add(result);
  }

  void selectHabit(Habit selectedHabit) {
    _appBarStateSubject.sink.add(AppBarState(true, selectedHabit));
  }

  void removeHabit(String habitId) {
    _removeUseCase.removeHabit(habitId);
    showMainAppBar();
  }

  void showMainAppBar() {
    _appBarStateSubject.sink.add(AppBarState(false, null));
    getHomeData();
  }

  void dispose() {
    _homeStateSubject.close();
    _logoutStateSubject.close();
  }
}
