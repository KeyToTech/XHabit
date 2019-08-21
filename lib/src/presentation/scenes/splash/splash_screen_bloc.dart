import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/splash_screen_use_case.dart';

import 'splash_screen_state.dart';

class SplashScreenBloc {
  BehaviorSubject<SplashScreenState> _splashStateSubject;
  Observable<SplashScreenState> get splashStateObservable => _splashStateSubject.stream;
  Future<dynamic> get closeStream => _splashStateSubject.close();
  SplashScreenUseCase _useCase;

  SplashScreenBloc(SplashScreenUseCase useCase) {
    _splashStateSubject = BehaviorSubject<SplashScreenState>();
    _useCase = useCase;
  }

  void loadSplash() {
    if(_useCase.isUserSignedIn()) {
      _splashStateSubject.sink.add(SplashScreenState(false, true));
    }
    else {
      _splashStateSubject.sink.add(SplashScreenState(true, false));
    }
  }
}