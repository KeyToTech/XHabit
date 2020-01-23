import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<User> signUp(String email, String password) {
    Future<User> getSignedUpUser() async {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('signUp $authResult');
      return User(authResult.user.uid, authResult.user.email);
    }

    return Stream.fromFuture(getSignedUpUser());
  }

  @override
  Stream<User> signIn(String email, String password) {
    Future<User> getSignedInUser() async {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('signIn ${authResult.user.email}');
      return User(authResult.user.uid, authResult.user.email);
    }

    return Stream.fromFuture(getSignedInUser());
  }

  @override
  Stream<bool> isSignedIn() {
    Future<bool> getIsSignedIn() async {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        return true;
      } else {
        return false;
      }
    }

    return Stream.fromFuture(getIsSignedIn());
  }

  @override
  Stream<bool> logout() {
    Future<bool> getLogoutResult() async {
      await _auth.signOut();
      return true;
    }

    return Stream.fromFuture(getLogoutResult());
  }
}
