import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:rxdart/rxdart.dart';

class LoginUseCase {
  final AuthService _service;

  LoginUseCase(this._service);

  Observable<User> login(String email, String password) {
    return _service.signIn(email, password);
  }
}
