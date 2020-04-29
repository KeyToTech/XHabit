import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/user_email_use_case.dart';

class SimpleUserEmailUseCase implements UserEmailUseCase {

  final UserRepository _repository;

  SimpleUserEmailUseCase(this._repository);

  @override
  void updateUserEmail(String email) => _repository.updateUserEmail(email);

  @override
  Stream<String> getUserEmail() => _repository.getUserEmail();
}