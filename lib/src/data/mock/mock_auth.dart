import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';

class MockAuth implements AuthService {
  @override
  Observable<User> signUp(String email, String password) {
    return null;
  }

  @override
  Observable<User> signIn(String email, String password) {
    return null;
  }

  @override
  Observable<bool> isSignedIn() => Observable.just(true);

  @override
  Observable<bool> logout() => Observable.just(true);
}
