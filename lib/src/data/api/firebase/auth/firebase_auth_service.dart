import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/entities/xh_auth_result.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.reference();

  @override
  Stream<XHAuthResult> signUp(String email, String password) {
    Future<XHAuthResult> getSignedUpUser() async {
      User user;
      String message;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((authResult) {
        user = User(authResult.user.uid, authResult.user.email);
      }).catchError((error) {
        message = AppConfig.authExceptionHandler.getErrorMessage(error);
      });

      return XHAuthResult(user, message);
    }

    return Stream.fromFuture(getSignedUpUser());
  }

  @override
  Stream<XHAuthResult> signIn(String email, String password) {
    Future<XHAuthResult> getSignedInUser() async {
      User user;
      String message;
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((authResult) {
        user = User(authResult.user.uid, authResult.user.email);
      }).catchError((error) {
        message = AppConfig.authExceptionHandler.getErrorMessage(error);
      });

      return XHAuthResult(user, message);
    }

    return Stream.fromFuture(getSignedInUser());
  }

  @override
  void updateUsername(String username) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.child(user.uid).child('username').set(
        username);
    print('username has been changed: $username');
  }

  @override
  Stream<String> getUsername(){
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      String result = ((await _database.child(userId)
          .child('username')
          .once())
          .value as String);
      result ??= 'empty';
      return result;
    }
    return Stream.fromFuture(getFuture());
  }

  @override
  Stream<String> getUserEmail(){
    getFuture() async {
      String email = (await _auth.currentUser()).email;
      return email;
    }
    return Stream.fromFuture(getFuture());
  }

  @override
  Stream<User> loginWithFacebook() {
    Future<User> getFbSignedInUser() async {
      User user;
      var fbLoginResult = await FacebookLogin().logIn(['email']);
      if (fbLoginResult.status == FacebookLoginStatus.loggedIn) {
        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: fbLoginResult.accessToken.token);
        AuthResult authResult = await _auth.signInWithCredential(credential);
        print('FB signIn ${authResult.user.email}');
        user = User(authResult.user.uid, authResult.user.email);
      }
      return user;
    }

    return Stream.fromFuture(getFbSignedInUser());
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
