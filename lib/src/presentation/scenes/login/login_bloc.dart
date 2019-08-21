import 'package:rxdart/rxdart.dart';
import 'login_state.dart';

class LoginBloc {
  BehaviorSubject<LoginState> _loginStateSubject;
  Observable<LoginState> get loginStateObservable => _loginStateSubject.stream;

  LoginBloc() {
    this._loginStateSubject = BehaviorSubject<LoginState>.seeded(
        LoginState(false, LoginResultState(false, null, false)));
  }
}
