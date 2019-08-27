import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/domain/login/login_use_case.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_state.dart';
import 'package:xhabits/src/data/entities/user.dart';

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
        false));

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
        LoginValidationsState(emailValid, passwordValid),
        emailValid.isValid &&
                passwordValid.isValid &&
                isNotEmptyEmail &&
                isNotEmptyPassword
            ? true
            : false,
        false));
  }

  void submit(String email, String password) {
    LoginUseCase(email, password).login().listen(handleLogin);
  }

  void handleLogin(User user) {
     print(user.email);
    if (user == null) {
      _loginStateSubject.sink.add(LoginState(
          LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
          false,
          false));
    } else {
      _loginStateSubject.sink.add(LoginState(
          LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
          false,
          true));
    }
  }
}
