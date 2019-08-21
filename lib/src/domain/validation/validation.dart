class ValidationResult {
  final bool isValid;
  final String errorMessage;

  ValidationResult(this.isValid, this.errorMessage);
}

abstract class Validation {
  ValidationResult validate(String text);
}
