import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';

class UserRepository {
  final AuthService _authService;

  UserRepository(this._authService);

  Stream<User> signUp(String email, String password) =>
      _authService.signUp(email, password);

  Stream<User> signIn(String email, String password) =>
      _authService.signIn(email, password);

  Stream<bool> isSignedIn() => _authService.isSignedIn();

  Stream<bool> logout() => _authService.logout();
}
