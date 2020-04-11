import 'package:xhabits/src/data/entities/xh_auth_result.dart';
import 'package:xhabits/src/data/user_repository.dart';

class RegisterUseCase {
  final UserRepository _repository;

  RegisterUseCase(this._repository);

  Stream<XHAuthResult> register(String email, String password) =>
      _repository.signUp(email, password);
}
