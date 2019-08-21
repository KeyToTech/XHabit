import 'package:xhabits/src/domain/validation/validation.dart';

class LoginValidationsState {
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  LoginValidationsState(this.emailValidation, this.passwordValidation);
}

class LoginResultState {
  final bool loggedIn;
  final String loginError;
  final bool loading;

  LoginResultState(this.loggedIn, this.loginError, this.loading);
}

class LoginState {
  final LoginValidationsState validationsState;
  final bool signInButtonEnabled;
  final LoginResultState loginResultState;

  LoginState(
      this.validationsState, this.signInButtonEnabled, this.loginResultState);
}
