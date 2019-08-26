import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';

class AuthBloc {
  BehaviorSubject<AuthState> _loginStateSubject;
  Observable<AuthState> get loginStateObservable => _loginStateSubject.stream;

  EmailValidation _emailValidation = new EmailValidation();
  PasswordValidation _passwordValidation = new PasswordValidation();
  UserNameValidation _userNameValidation = new UserNameValidation();

  final _defaultTextInputState = ValidationResult(true, null);

  AuthBloc() {
    _loginStateSubject = BehaviorSubject<AuthState>.seeded(AuthState(
        AuthValidationsState(_defaultTextInputState, _defaultTextInputState,
            _defaultTextInputState),
        false,
        AuthResultState(false)));
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
  }

  void loginValidate(String email, String password) {
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

    _loginStateSubject.sink.add(AuthState(
        AuthValidationsState(_defaultTextInputState, emailValid, passwordValid),
        emailValid.isValid &&
            isNotEmptyEmail &&
            isNotEmptyPassword &&
            passwordValid.isValid,
        AuthResultState(false)));
  }

  void registerValidate(String username, String email, String password) {
    ValidationResult usernameValid = _defaultTextInputState;
    ValidationResult emailValid = _defaultTextInputState;
    ValidationResult passwordValid = _defaultTextInputState;
    bool isNotEmptyUserName = username.isNotEmpty;
    bool isNotEmptyEmail = email.isNotEmpty;
    bool isNotEmptyPassword = password.isNotEmpty;

    if (isNotEmptyUserName) {
      usernameValid = _userNameValidation.validate(username);
    }
    if (isNotEmptyEmail) {
      emailValid = _emailValidation.validate(email);
    }
    if (isNotEmptyPassword) {
      passwordValid = _passwordValidation.validate(password);
    }

    _loginStateSubject.sink.add(AuthState(
        AuthValidationsState(usernameValid, emailValid, passwordValid),
        emailValid.isValid &&
            isNotEmptyUserName &&
            isNotEmptyEmail &&
            isNotEmptyPassword &&
            passwordValid.isValid,
        AuthResultState(false)));
  }

  void login() {
    _loginStateSubject.sink.add(AuthState(
        AuthValidationsState(_defaultTextInputState, _defaultTextInputState,
            _defaultTextInputState),
        true,
        AuthResultState(true)));
  }
}
