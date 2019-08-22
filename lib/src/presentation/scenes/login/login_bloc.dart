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
    this._loginStateSubject = BehaviorSubject<LoginState>.seeded(LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        false,
        LoginResultState(false, null, false)));
    this._emailValidation = EmailValidation();
    this._passwordValidation = PasswordValidation();
  }

  void validate(String email, String password) {
    ValidationResult emailValid = _defaultTextInputState;
    ValidationResult passwordValid = _defaultTextInputState;
    bool isEmptyEmail = email.isEmpty;
    bool isEmptyPassword = password.isEmpty;
    if (!isEmptyEmail) {
      emailValid = this._emailValidation.validate(email);
    }
    if (!isEmptyPassword) {
      passwordValid = this._passwordValidation.validate(password);
    }

    if (!isEmptyEmail || !isEmptyPassword) {
      this._loginStateSubject.sink.add(LoginState(
          LoginValidationsState(emailValid, passwordValid),
          emailValid.isValid &&
              !isEmptyEmail &&
              passwordValid.isValid &&
              !isEmptyPassword,
          LoginResultState(false, null, false)));
    }
  }
}
