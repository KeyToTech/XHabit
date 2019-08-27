import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_state.dart';

class RegisterBloc {
  BehaviorSubject<RegisterState> _registerStateSubject;

  Observable<RegisterState> get registerStateObservable =>
      _registerStateSubject.stream;

  UserNameValidation _userNameValidation;
  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;

  final _defaultTextInputState = ValidationResult(true, null);

  RegisterBloc() {
    _registerStateSubject = BehaviorSubject<RegisterState>.seeded(RegisterState(
        RegisterValidationsState(_defaultTextInputState, _defaultTextInputState,
            _defaultTextInputState),
        false,
        false));
    _userNameValidation = UserNameValidation();
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
  }

  void validate(String userName, String email, String password) {
    ValidationResult userNameValid = _defaultTextInputState;
    ValidationResult emailValid = _defaultTextInputState;
    ValidationResult passwordValid = _defaultTextInputState;
    bool isNotEmptyUserName = userName.isNotEmpty;
    bool isNotEmptyEmail = email.isNotEmpty;
    bool isNotEmptyPassword = password.isNotEmpty;

    if (isNotEmptyUserName) {
      userNameValid = _userNameValidation.validate(userName);
    }
    if (isNotEmptyEmail) {
      emailValid = _emailValidation.validate(email);
    }
    if (isNotEmptyPassword) {
      passwordValid = _passwordValidation.validate(password);
    }

    _registerStateSubject.sink.add(RegisterState(
        RegisterValidationsState(userNameValid, emailValid, passwordValid),
        userNameValid.isValid &&
                emailValid.isValid &&
                passwordValid.isValid &&
                isNotEmptyUserName &&
                isNotEmptyEmail &&
                isNotEmptyPassword
            ? true
            : false,
        false));
  }
}
