import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'login_state.dart';

class LoginBloc {
  BehaviorSubject<LoginState> _loginStateSubject;
  Observable<LoginState> get loginStateObservable => _loginStateSubject.stream;

  final _defaultTextInputState = ValidationResult(true, null);

  LoginBloc() {
    this._loginStateSubject = BehaviorSubject<LoginState>.seeded(LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        false,
        LoginResultState(false, null, false)));
  }
  void validate(String email, String password) {}
}
