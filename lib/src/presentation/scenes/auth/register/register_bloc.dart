import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/domain/register/register_use_case.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_state.dart';

class RegisterBloc {
  BehaviorSubject<RegisterState> _registerStateSubject;

  Observable<RegisterState> get registerStateObservable =>
      _registerStateSubject.stream;

  Future<dynamic> get closeStream => _registerStateSubject.close();

  final RegisterUseCase _registerUseCase;

  UserNameValidation _userNameValidation;
  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;

  final _defaultTextInputState = ValidationResult(true, null);

  RegisterBloc(this._registerUseCase) {
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

  void register(String email, String password) {
    _registerUseCase
        .register(email, password)
        .handleError((error) => print('HandleError ${error}'))
        .listen(handleRegister);
  }

  void handleRegister(User user) {
    print(user.email);
    if (user == null) {
      _registerStateSubject.sink.add(RegisterState(
          RegisterValidationsState(_defaultTextInputState,
              _defaultTextInputState, _defaultTextInputState),
          false,
          false));
    } else {
      _registerStateSubject.sink.add(RegisterState(
          RegisterValidationsState(_defaultTextInputState,
              _defaultTextInputState, _defaultTextInputState),
          false,
          true));
    }
  }
}
