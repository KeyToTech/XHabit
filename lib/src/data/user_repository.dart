import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/entities/xh_auth_result.dart';

class UserRepository {
  final AuthService _authService;

  UserRepository(this._authService);

  Stream<XHAuthResult> signUp(String email, String password) =>
      _authService.signUp(email, password);

  Stream<XHAuthResult> signIn(String email, String password) =>
      _authService.signIn(email, password);

  void updateUsername(String username) => _authService.updateUsername(username);

  Stream<String> getUserEmail() => _authService.getUserEmail();

  Stream<String> getUsername() => _authService.getUsername();

  Stream<User> loginWithFacebook() => _authService.loginWithFacebook();

  Stream<bool> isSignedIn() => _authService.isSignedIn();

  Stream<bool> logout() => _authService.logout();
}
