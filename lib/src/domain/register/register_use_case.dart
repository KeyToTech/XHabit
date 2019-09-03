import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:rxdart/rxdart.dart';

class RegisterUseCase {
  final AuthService _service;

  RegisterUseCase(this._service);

  Observable<User> register(String email, String password) {
    return _service.signUp(email, password);
  }
}
