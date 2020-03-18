import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';

class MockAuth implements AuthService {
  @override
  Stream<User> signUp(String email, String password) => null;

  @override
  Stream<User> signIn(String email, String password) => null;

  @override
  Stream<bool> isSignedIn() => Stream.value(true);

  @override
  Stream<bool> logout() => Stream.value(true);

  @override
  Stream<User> loginWithFacebook() => null;
}
