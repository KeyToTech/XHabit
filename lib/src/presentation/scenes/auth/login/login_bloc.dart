import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/xh_auth_result.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/domain/login/login_use_case.dart';
import 'package:xhabits/src/presentation/resource.dart';
import 'package:xhabits/src/presentation/scenes/auth/login/login_state.dart';

class LoginBloc {

  BehaviorSubject<Resource<LoginState>> _loginStateSubject;

  Stream<Resource<LoginState>> get loginStateObservable =>
      _loginStateSubject.stream;

  Future<dynamic> get closeStream => _loginStateSubject.close();

  final LoginUseCase _loginUseCase;
  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;

  final _defaultTextInputState = ValidationResult(true, null);
  LoginValidationsState _defaultValidationState;
  LoginState _initialState;

  LoginBloc(this._loginUseCase) {
    _initialState = LoginState(
        LoginValidationsState(_defaultTextInputState, _defaultTextInputState),
        false);
    _emailValidation = EmailValidation();
    _passwordValidation = PasswordValidation();
    _loginStateSubject = BehaviorSubject<Resource<LoginState>>.seeded(
        Resource.initial(_initialState));
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

  void login(String email, String password) {
    _loginStateSubject.sink.add(Resource.loading(_initialState));
    _loginUseCase.login(email, password).listen(handleLogin);
  }

  void handleLogin(XHAuthResult authResult) {
    if (authResult.user != null) {
      _loginStateSubject.sink.add(Resource.success(_initialState));
    } else {
      handleError(authResult.message);
    }
  }

  void initialState() {
    _loginStateSubject.sink.add(Resource.initial(_initialState));
  }

  void handleError(String errorMessage) {
    _loginStateSubject.sink
        .add(Resource.errorWithData(errorMessage, _initialState));
  }
}
