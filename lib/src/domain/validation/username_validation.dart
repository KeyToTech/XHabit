import 'validation.dart';

class UserNameValidation implements Validation {
  @override
  ValidationResult validate(String text) {
    ValidationResult validationResult;
    if (text.length > 4) {
      validationResult = ValidationResult(true, null);
    } else {
      validationResult =
          ValidationResult(false, "user name should be more then 4 symbols");
    }
    return validationResult;
  }
}
