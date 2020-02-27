import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/domain/login/login_use_case.dart';
import 'package:xhabits/src/presentation/resource.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_state.dart';
import 'package:xhabits/src/data/entities/user.dart';

class LoginBloc {
  bool visiblePassword;
  BehaviorSubject<Resource<LoginState>> _loginStateSubject;
  BehaviorSubject<bool> _visiblePasswordSubject;

  Stream<Resource<LoginState>> get loginStateObservable =>
      _loginStateSubject.stream;

  Stream<bool> get visiblePasswordObservable => _visiblePasswordSubject.stream;

  Future<dynamic> get closeStream => _loginStateSubject.close();

  final LoginUseCase _loginUseCase;
  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;

  final _defaultTextInputState = ValidationResult(true, null);
  LoginValidationsState _defaultValidationState;
  LoginState _initialState;

  LoginBloc(this._loginUseCase) {
    visiblePassword = false;
    _initialState = LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        false);
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
    _loginStateSubject = BehaviorSubject<Resource<LoginState>>.seeded(
        Resource.initial(_initialState));
    _visiblePasswordSubject =
    BehaviorSubject<bool>.seeded(visiblePassword);
    _defaultValidationState =
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState);
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

    _loginStateSubject.sink.add(Resource.initial(LoginState(
        LoginValidationsState(emailValid, passwordValid),
        emailValid.isValid &&
                passwordValid.isValid &&
                isNotEmptyEmail &&
                isNotEmptyPassword
            ? true
            : false)));
  }

  void passwordVisibilityChanged() {
    visiblePassword = !visiblePassword;
    _visiblePasswordSubject.sink.add(visiblePassword);
  }

  void login(String email, String password) {
    _loginStateSubject.sink.add(Resource.loading(_initialState));

    _loginUseCase.login(email, password).listen(handleLogin, onDone: () {
      print('DONE');
    }, onError: (error) {
      if (error.runtimeType == PlatformException) {
        handleError(error as PlatformException);
      } else {
        handleError(PlatformException(code: '400'));
      }
    });
  }

  void handleLogin(User user) {
    if (user != null) {
      _loginStateSubject.sink.add(Resource.success(_initialState));
    } else {
      _loginStateSubject.sink.add(Resource.error('Could not login'));
    }
  }

  void handleError(PlatformException error) {
    print('ERR ${error.toString()}');
    _loginStateSubject.sink
        .add(Resource.errorWithData(error.message, _initialState));
  }
}
