import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';

class FirebaseAuth implements AuthService {

  @override
  Observable<User> signIn(String email, String password) {
    // TODO: implement signIn https://trello.com/c/FUrFa7XS/28-firebase-login
    return null;
  }

  @override
  Observable<bool> isSignedIn() {
    // TODO: implement isSignedIn https://trello.com/c/FUrFa7XS/28-firebase-login
    return null;
  }
}