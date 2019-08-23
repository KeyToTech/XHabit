import 'package:xhabits/src/domain/validation/validation.dart';

class RegisterValidationsState {
  final ValidationResult usernameValidation;
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  RegisterValidationsState(
      this.usernameValidation, this.emailValidation, this.passwordValidation);
}

class RegisterResultState {
  final bool loggedIn;

  RegisterResultState(this.loggedIn);
}

class RegisterState {
  final RegisterValidationsState validationsState;
  final bool signInButtonEnabled;
  final RegisterResultState loginResultState;

  RegisterState(
      this.validationsState, this.signInButtonEnabled, this.loginResultState);
}
