import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/entities/xh_auth_result.dart';

class MockAuth implements AuthService {
  @override
  Stream<XHAuthResult> signUp(String email, String password) => null;

  @override
  Stream<XHAuthResult> signIn(String email, String password) => null;

  @override
  BehaviorSubject<bool> updateUsername(String name) => null;

  @override
  Stream<String> getUsername() => null;

  @override
  Stream<bool> isSignedIn() => Stream.value(true);

  @override
  Stream<bool> logout() => Stream.value(true);

  @override
  Stream<User> loginWithFacebook() => null;
}
