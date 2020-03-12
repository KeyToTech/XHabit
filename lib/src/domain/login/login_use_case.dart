import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/user_repository.dart';

class LoginUseCase {
  final UserRepository _repository;

  LoginUseCase(this._repository);

  Stream<User> login(String email, String password) =>
      _repository.signIn(email, password);
}
