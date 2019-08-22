import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'login_state.dart';

class LoginBloc {
  BehaviorSubject<LoginState> _loginStateSubject;
  Observable<LoginState> get loginStateObservable => _loginStateSubject.stream;

  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;

  final _defaultTextInputState = ValidationResult(true, null);

  LoginBloc() {
    _loginStateSubject = BehaviorSubject<LoginState>.seeded(LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        false,
        LoginResultState(false)));
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
  }

  void validate(String email, String password) {
    ValidationResult emailValid = _defaultTextInputState;
    ValidationResult passwordValid = _defaultTextInputState;
    bool isEmptyEmail = email.isEmpty;
    bool isEmptyPassword = password.isEmpty;
    if (!isEmptyEmail) {
      emailValid = _emailValidation.validate(email);
    }
    if (!isEmptyPassword) {
      passwordValid = _passwordValidation.validate(password);
    }

    if (!isEmptyEmail || !isEmptyPassword) {
      _loginStateSubject.sink.add(LoginState(
          LoginValidationsState(emailValid, passwordValid),
          emailValid.isValid &&
              !isEmptyEmail &&
              passwordValid.isValid &&
              !isEmptyPassword,
          LoginResultState(false)));
    }
  }

  void login() {
    _loginStateSubject.sink.add(LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        true,
        LoginResultState(true)));
  }
}
