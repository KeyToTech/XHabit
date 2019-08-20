import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/userRepository.dart';

import 'splashScreenState.dart';

class SplashScreenBloc {
  BehaviorSubject<SplashScreenState> _splashStateSubject;
  Observable<SplashScreenState> get splashStateObservable => _splashStateSubject.stream;
  Future<dynamic> get closeStream => _splashStateSubject.close();
  UserRepository _repository;

  SplashScreenBloc() {
    _splashStateSubject = BehaviorSubject<SplashScreenState>();
    _repository = UserRepository();
  }

  void loadSplash() {
    if(_repository.isUserSignedIn()) {
      _splashStateSubject.sink.add(SplashScreenState(false, true));
    }
    else {
      _splashStateSubject.sink.add(SplashScreenState(true, false));
    }
  }
}