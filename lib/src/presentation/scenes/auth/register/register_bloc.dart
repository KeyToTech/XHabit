import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/xh_auth_result.dart';
import 'package:xhabits/src/domain/register/register_use_case.dart';
import 'package:xhabits/src/domain/update_username_use_case.dart';
import 'package:xhabits/src/domain/user_email_use_case.dart';
import 'package:xhabits/src/domain/validation/validation.dart';
import 'package:xhabits/src/domain/validation/username_validation.dart';
import 'package:xhabits/src/domain/validation/email_validation.dart';
import 'package:xhabits/src/domain/validation/password_validation.dart';
import 'package:xhabits/src/presentation/resource.dart';
import 'package:xhabits/src/presentation/scenes/auth/register/register_state.dart';

class RegisterBloc {
  String _username;
  String _email;

  BehaviorSubject<Resource<RegisterState>> _registerStateSubject;

  Stream<Resource<RegisterState>> get registerStateObservable =>
      _registerStateSubject.stream;

  Future<dynamic> get closeStream => _registerStateSubject.close();

  RegisterUseCase _registerUseCase;
  UpdateUsernameUseCase _usernameUseCase;
  UserEmailUseCase _emailUseCase;

  UserNameValidation _userNameValidation;
  EmailValidation _emailValidation;
  PasswordValidation _passwordValidation;

  final _defaultTextInputState = ValidationResult(true, null);
  RegisterState _initialState;

  RegisterBloc(RegisterUseCase registerUseCase,
      UpdateUsernameUseCase usernameUseCase, UserEmailUseCase emailUseCase) {
    this._registerUseCase = registerUseCase;
    this._usernameUseCase = usernameUseCase;
    this._emailUseCase = emailUseCase;
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

  void register(String email, String password, String username) {
    _registerStateSubject.sink.add(Resource.loading(_initialState));
    _registerUseCase.register(email, password).listen(handleRegister);
    _username = username;
    _email = email;
  }

  void updateUsername(String un) {
    _usernameUseCase.updateUsername(un);
  }

  void handleRegister(XHAuthResult authResult) {
    if (authResult.user != null) {
      _usernameUseCase.updateUsername(_username);
      _emailUseCase.updateUserEmail(_email);
      _registerStateSubject.sink.add(Resource.success(_initialState));
    } else {
      handleError(authResult.message);
    }
  }

  void initialState() {
    _registerStateSubject.sink.add(Resource.initial(_initialState));
  }

  void handleError(String errorMessage) {
    _registerStateSubject.sink
        .add(Resource.errorWithData(errorMessage, _initialState));
  }
}
