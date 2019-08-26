import 'validation.dart';

class UserNameValidation implements Validation {
  @override
  ValidationResult validate(String text) {
    ValidationResult validationResult;
    if (text.length > 3) {
      validationResult = ValidationResult(true, null);
    } else {
      validationResult =
          ValidationResult(false, "User name should be more then 3 letters");
    }
    return validationResult;
  }
}
