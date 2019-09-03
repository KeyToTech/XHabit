import 'package:xhabits/src/domain/validation/validation.dart';

class LoginValidationsState {
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  LoginValidationsState(this.emailValidation, this.passwordValidation);
}

class LoginState {
  final LoginValidationsState loginValidationsState;
  final bool signInButtonEnabled;
  final bool loggedIn;
  final String errorMessage;
  final bool showLoading;

  LoginState(this.loginValidationsState, this.signInButtonEnabled,
      this.loggedIn, this.errorMessage, this.showLoading);
}
