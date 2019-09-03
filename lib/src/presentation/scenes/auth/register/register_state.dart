import 'package:xhabits/src/domain/validation/validation.dart';

class RegisterValidationsState {
  final ValidationResult userNameValidation;
  final ValidationResult emailValidation;
  final ValidationResult passwordValidation;

  RegisterValidationsState(
      this.userNameValidation, this.emailValidation, this.passwordValidation);
}

class RegisterState {
  final RegisterValidationsState registerValidationsState;
  final bool signUpButtonEnabled;
  final bool signedUp;

  RegisterState(
    this.registerValidationsState,
    this.signUpButtonEnabled,
    this.signedUp,
  );
}
