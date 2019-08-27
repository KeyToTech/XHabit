import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';

import 'habit_screen_state.dart';

class HomeScreenBlock {
  BehaviorSubject<HomeScreenResource> _homeStateSubject;

  Observable<HomeScreenResource> get homeScreenStateObservable =>
      _homeStateSubject.stream;

  HomeScreenUseCase _useCase;

  HomeScreenBlock(HomeScreenUseCase useCase) {
    _homeStateSubject = BehaviorSubject<HomeScreenResource>();
    _useCase = useCase;
  }

  void init() {
    _homeStateSubject.sink.add(HomeScreenResource(_useCase.weekDays(), false));
  }
}
