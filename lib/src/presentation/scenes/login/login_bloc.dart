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
    ValidationResult emailValid = this._emailValidation.validate(email);
    ValidationResult passwordValid =
        this._passwordValidation.validate(password);
    this._loginStateSubject.sink.add(LoginState(
        LoginValidationsState(emailValid, passwordValid),
        emailValid.isValid && passwordValid.isValid,
        LoginResultState(false, null, false)));
  }
}
