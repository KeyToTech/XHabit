import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/user_repository.dart';

class RegisterUseCase {
  final UserRepository _repository;

  RegisterUseCase(this._repository);

  Stream<User> register(String email, String password) =>
      _repository.signUp(email, password);
}
