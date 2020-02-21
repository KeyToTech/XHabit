import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';

class RegisterUseCase {
  final AuthService _service;

  RegisterUseCase(this._service);

  Stream<User> register(String email, String password) => _service.signUp(email, password);
}
