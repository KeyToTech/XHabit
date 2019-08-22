import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/check_user_is_signed_use_case.dart';

import 'splash_screen_state.dart';

class SplashScreenBloc {
  BehaviorSubject<SplashScreenState> _splashStateSubject;
  Observable<SplashScreenState> get splashStateObservable => _splashStateSubject.stream;
  Future<dynamic> get closeStream => _splashStateSubject.close();
  CheckUserIsSignedInUseCase _useCase;

  SplashScreenBloc(CheckUserIsSignedInUseCase useCase) {
    _splashStateSubject = BehaviorSubject<SplashScreenState>();
    _useCase = useCase;
  }

  void loadSplash() {
    _useCase.isUserSignedIn().listen(handleSignInCheck);
  }

  void handleSignInCheck(bool isSignedIn) {
    if(isSignedIn) {
      _splashStateSubject.sink.add(SplashScreenState(false, true));
    }
    else {
      _splashStateSubject.sink.add(SplashScreenState(true, false));
    }
  }
}