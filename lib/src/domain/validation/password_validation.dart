import 'validation.dart';

class PasswordValidation implements Validation {
  @override
  ValidationResult validate(String text) {
    ValidationResult validationResult;
    if (text.length > 5) {
      validationResult = ValidationResult(true, null);
    } else {
      validationResult =
          ValidationResult(false, "Password must be at least 6 characters long");
    }
    return validationResult;
  }
}
