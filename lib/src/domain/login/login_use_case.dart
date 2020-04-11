import 'package:xhabits/src/data/entities/xh_auth_result.dart';
import 'package:xhabits/src/data/user_repository.dart';

class LoginUseCase {
  final UserRepository _repository;

  LoginUseCase(this._repository);

  Stream<XHAuthResult> login(String email, String password) =>
      _repository.signIn(email, password);
}
