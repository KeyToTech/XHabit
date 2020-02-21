import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';

class LoginUseCase {
  final AuthService _service;

  LoginUseCase(this._service);

  Stream<User> login(String email, String password) => _service.signIn(email, password);
}
