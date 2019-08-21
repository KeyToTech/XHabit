import 'package:rxdart/rxdart.dart';
import 'login_state.dart';

class LoginBlock {
  BehaviorSubject<LoginState> _loginStateSubject;
  Observable<LoginState> get loginStateObservable => _loginStateSubject.stream;

  LoginBlock() {
    this._loginStateSubject = BehaviorSubject<LoginState>.seeded(
        LoginState(false, LoginResultState(false, "Working", false)));
  }
}
