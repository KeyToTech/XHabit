import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_state.dart';

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
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState,
            _defaultTextInputState),
        false,
        LoginResultState(false)));
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
  }

  void validate(String email, String password) {
    ValidationResult emailValid = _defaultTextInputState;
    ValidationResult passwordValid = _defaultTextInputState;
    bool isNotEmptyEmail = email.isNotEmpty;
    bool isNotEmptyPassword = password.isNotEmpty;

    if (isNotEmptyEmail) {
      emailValid = _emailValidation.validate(email);
    }
    if (isNotEmptyPassword) {
      passwordValid = _passwordValidation.validate(password);
    }

    _loginStateSubject.sink.add(LoginState(
        LoginValidationsState(
            _defaultTextInputState, emailValid, passwordValid),
        emailValid.isValid &&
            isNotEmptyEmail &&
            isNotEmptyPassword &&
            passwordValid.isValid,
        LoginResultState(false)));
  }

  void registerValidate(String username, String email, String password) {
    ValidationResult usernameValid = _defaultTextInputState;
    ValidationResult emailValid = _defaultTextInputState;
    ValidationResult passwordValid = _defaultTextInputState;
    bool isNotEmptyUserName = username.isNotEmpty;
    bool isNotEmptyEmail = email.isNotEmpty;
    bool isNotEmptyPassword = password.isNotEmpty;

    if (isNotEmptyUserName) {}
    if (isNotEmptyEmail) {
      emailValid = _emailValidation.validate(email);
    }
    if (isNotEmptyPassword) {
      passwordValid = _passwordValidation.validate(password);
    }

    _loginStateSubject.sink.add(LoginState(
        LoginValidationsState(usernameValid, emailValid, passwordValid),
        emailValid.isValid &&
            isNotEmptyUserName &&
            isNotEmptyEmail &&
            isNotEmptyPassword &&
            passwordValid.isValid,
        LoginResultState(false)));
  }

  void login() {
    _loginStateSubject.sink.add(LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState,
            _defaultTextInputState),
        true,
        LoginResultState(true)));
  }
}
