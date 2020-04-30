import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/entities/xh_auth_result.dart';

abstract class AuthService {
  Stream<XHAuthResult> signUp(String email, String password);

  Stream<XHAuthResult> signIn(String email, String password);

  void updateUsername(String username);

  Stream<String> getUserEmail();

  Stream<String> getUsername();

  Stream<User> loginWithFacebook();

  Stream<bool> isSignedIn();

  Stream<bool> logout();
}
