import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/domain/register/register_use_case.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/presentation/resource.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_state.dart';

class RegisterBloc {
  BehaviorSubject<Resource<RegisterState>> _registerStateSubject;

  Observable<Resource<RegisterState>> get registerStateObservable =>
      _registerStateSubject.stream;

  Future<dynamic> get closeStream => _registerStateSubject.close();

  final RegisterUseCase _registerUseCase;

  UserNameValidation _userNameValidation;
  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;

  final _defaultTextInputState = ValidationResult(true, null);
  RegisterState _initialState;

  RegisterBloc(this._registerUseCase) {
    _initialState = RegisterState(
        RegisterValidationsState(_defaultTextInputState, _defaultTextInputState,
            _defaultTextInputState),
        false,
        false);
    _registerStateSubject = BehaviorSubject<Resource<RegisterState>>.seeded(
        Resource.initial(_initialState));
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

    _registerStateSubject.sink.add(Resource(
        Status.INITIAL,
        RegisterState(
            RegisterValidationsState(userNameValid, emailValid, passwordValid),
            userNameValid.isValid &&
                    emailValid.isValid &&
                    passwordValid.isValid &&
                    isNotEmptyUserName &&
                    isNotEmptyEmail &&
                    isNotEmptyPassword
                ? true
                : false,
            false),
        null));
  }

  void register(String email, String password) {
    _registerStateSubject.sink.add(Resource.loading(_initialState));
    _registerUseCase.register(email, password).listen(handleRegister,
        onDone: () {
      print('DONE');
    }, onError: (error) {
      if (error.runtimeType == PlatformException) {
        handleError(error as PlatformException);
      } else {
        handleError(PlatformException(code: '400'));
      }
    });
  }

  void handleRegister(User user) {
    if (user == null) {
      _registerStateSubject.sink.add(Resource.success(RegisterState(
          RegisterValidationsState(_defaultTextInputState,
              _defaultTextInputState, _defaultTextInputState),
          false,
          false)));
    } else {
      handleError(PlatformException(code: '400'));
    }
  }

  void handleError(PlatformException error) {
    print('ERR ${error.toString()}');
    _registerStateSubject.sink
        .add(Resource.errorWithData(error.message, _initialState));
  }
}
