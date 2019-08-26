import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Observable<User> signUp(String email, String password) {
    Future<User> getSignedUpUser() async {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return User(authResult.user.uid, authResult.user.email);
    }

    return Observable.fromFuture(getSignedUpUser());
  }

  @override
  Observable<User> signIn(String email, String password) {
    Future<User> getSignedInUser() async {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return User(authResult.user.uid, authResult.user.email);
    }

    return Observable.fromFuture(getSignedInUser());
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
