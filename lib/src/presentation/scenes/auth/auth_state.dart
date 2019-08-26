import 'package:xhabits/src/domain/validation/validation.dart';

class AuthValidationsState {
  final ValidationResult usernameValidation;
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  AuthValidationsState(
      this.usernameValidation, this.emailValidation, this.passwordValidation);
}

class AuthResultState {
  final bool loggedIn;

  AuthResultState(this.loggedIn);
}

class AuthState {
  final AuthValidationsState validationsState;
  final bool signInButtonEnabled;
  final AuthResultState loginResultState;

  AuthState(
      this.validationsState, this.signInButtonEnabled, this.loginResultState);
}
