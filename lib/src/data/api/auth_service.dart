import 'package:xhabits/src/data/entities/user.dart';

abstract class AuthService {
  Stream<User> signUp(String email, String password);

  Stream<User> signIn(String email, String password);

  Stream<User> loginWithFacebook();

  Stream<bool> isSignedIn();

  Stream<bool> logout();
}
