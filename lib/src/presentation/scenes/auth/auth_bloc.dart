import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';

class LoginBloc {
  BehaviorSubject<LoginState> _loginStateSubject;
  Observable<LoginState> get loginStateObservable => _loginStateSubject.stream;

  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;
  String email;
  String password;

  final _defaultTextInputState = ValidationResult(true, null);

  LoginBloc() {
    _loginStateSubject = BehaviorSubject<LoginState>.seeded(LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        false,
        LoginResultState(false)));
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
  }

  void validate(String text, String type) {
    ValidationResult emailValid;
    ValidationResult passwordValid;

    emailValid = _defaultTextInputState;
    passwordValid = _defaultTextInputState;

    switch (type) {
      case "Email":
        emailValid = _emailValidation.validate(text);
        email = text;
        break;
      case "Password":
        passwordValid = _passwordValidation.validate(text);
        password = text;
        break;
    }

    _loginStateSubject.sink.add(LoginState(
        LoginValidationsState(emailValid, passwordValid),
        emailValid.isValid && text.isNotEmpty && passwordValid.isValid,
        LoginResultState(false)));
  }

  void login() {
    _loginStateSubject.sink.add(LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        true,
        LoginResultState(true)));
  }
}
