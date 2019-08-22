import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Observable<User> signIn(String email, String password) {
    // TODO: implement signIn https://trello.com/c/FUrFa7XS/28-firebase-login
    return null;
  }

  @override
  Observable<bool> isSignedIn() {
    Future<bool> getIsSignedIn() async {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        return true;
      } else {
        return false;
      }
    }

    return Observable.fromFuture(getIsSignedIn());
  }
}
