import 'package:xhabits/src/domain/validation/validation.dart';

class LoginValidationsState {
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  LoginValidationsState(this.emailValidation, this.passwordValidation);
}

class LoginResultState {
  final bool loggedIn;

  LoginResultState(this.loggedIn);
}

class LoginState {
  final LoginValidationsState validationsState;
  final bool signInButtonEnabled;
  final LoginResultState loginResultState;

  LoginState(
      this.validationsState, this.signInButtonEnabled, this.loginResultState);
}
