import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';

import 'habit_screen_state.dart';

class HomeScreenBloc {
  BehaviorSubject<bool> _logoutStateSubject;
  BehaviorSubject<HomeScreenResource> _homeStateSubject;

  Observable<HomeScreenResource> get homeScreenStateObservable =>
      _homeStateSubject.stream;

  Observable<bool> get logoutStateObservable => _logoutStateSubject.stream;

  HomeScreenUseCase _useCase;
  LogoutUseCase _logoutUseCase;

  HomeScreenBloc(HomeScreenUseCase useCase, LogoutUseCase logoutUseCase) {
    _useCase = useCase;
    _logoutUseCase = logoutUseCase;
    _homeStateSubject = BehaviorSubject<HomeScreenResource>();
    _logoutStateSubject = BehaviorSubject<bool>();
  }

  void getHomeData() {
    _useCase.habitIds().listen(handleHomeData);
  }

  void handleHomeData(List<String> habitIds) {
    _homeStateSubject.sink.add(HomeScreenResource(
        habitIds, _useCase.weekDays(), _useCase.daysWords(), false));
  }

  void logout() {
    _logoutUseCase.logout().listen(onLogout);
  }

  void onLogout(bool result) {
    _logoutStateSubject.sink.add(result);
  }

  void dispose() {
    _homeStateSubject.close();
    _logoutStateSubject.close();
  }
}
