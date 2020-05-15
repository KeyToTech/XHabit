import 'validation.dart';

class UserNameValidation implements Validation {
  @override
  ValidationResult validate(String text) {
    ValidationResult validationResult;
    if (text.length > 3 && text.length < 31) {
      validationResult = ValidationResult(true, null);
    } else {
      validationResult =
          ValidationResult(false, "Username must contains from 4 to 30 symbols");
    }
    return validationResult;
  }
}
