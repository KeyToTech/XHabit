import 'package:xhabits/src/domain/validation/validation.dart';

class SignInValidationsState {
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  SignInValidationsState(this.emailValidation, this.passwordValidation);
}

class SignUpValidationsState {
  final ValidationResult usernameValidation;
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  SignUpValidationsState(
      this.usernameValidation, this.emailValidation, this.passwordValidation);
}

class AuthState {
  final bool signInButtonEnabled;
  final bool loggedIn;

  AuthState(
    this.signInButtonEnabled,
    this.loggedIn,
  );
}
