import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';
import 'package:xhabits/src/presentation/scenes/auth/auth_state.dart';

class AuthBloc {
  BehaviorSubject<SignInValidationsState> _loginStateSubject;
  BehaviorSubject<SignUpValidationsState> _registerStateSubject;
  BehaviorSubject<AuthState> _authStateSubject;
  Observable<SignInValidationsState> get loginStateObservable =>
      _loginStateSubject.stream;
  Observable<SignUpValidationsState> get registerStateObservable =>
      _registerStateSubject.stream;
  Observable<AuthState> get authStateObservable => _authStateSubject.stream;

  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;
  UserNameValidation _userNameValidation;

  final _defaultTextInputState = ValidationResult(true, null);

  AuthBloc() {
    _loginStateSubject = BehaviorSubject<SignInValidationsState>.seeded(
        SignInValidationsState(_defaultTextInputState, _defaultTextInputState));
    _registerStateSubject = BehaviorSubject<SignUpValidationsState>.seeded(
        SignUpValidationsState(_defaultTextInputState, _defaultTextInputState,
            _defaultTextInputState));
    _authStateSubject =
        BehaviorSubject<AuthState>.seeded(AuthState(false, false));
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
    _userNameValidation = UserNameValidation();
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

    _loginStateSubject.sink
        .add(SignInValidationsState(emailValid, passwordValid));
    if (emailValid.isValid &&
        passwordValid.isValid &&
        isNotEmptyEmail &&
        isNotEmptyPassword) {
      _authStateSubject.sink.add(AuthState(true, false));
    } else {
      _authStateSubject.sink.add(AuthState(false, false));
    }
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

    _registerStateSubject.sink
        .add(SignUpValidationsState(usernameValid, emailValid, passwordValid));
  }
}
