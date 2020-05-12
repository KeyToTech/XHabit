import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/entities/xh_auth_result.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseStorage.instance;
  final _database = FirebaseDatabase.instance.reference();
  final BehaviorSubject<bool> _imageUploadStatusSubject =
      BehaviorSubject<bool>();

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

  void _uploadProfilePic(File image) async {
    _imageUploadStatusSubject.sink.add(true);
    String userId = (await _auth.currentUser()).uid;
    var storageReference = _firestore
        .ref()
        .child(userId)
        .child('pic');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File uploaded');
    _imageUploadStatusSubject.sink.add(false);
    var imageURL = await storageReference.getDownloadURL();
    var stringURL = imageURL.toString();
    await _database
        .child(userId)
        .child('image')
        .set({
      'url': stringURL
    });
  }

  void _uploadProfilePicByURL(String imageURL) async {
    String userId = (await _auth.currentUser()).uid;
    await _database.child(userId).child('image').set({'url': imageURL});
  }

  @override
  BehaviorSubject<bool> uploadProfilePic(File image) {
    _uploadProfilePic(image);
    return _imageUploadStatusSubject;
  }

  @override
  Stream<String> getProfilePic() {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      String result = ((await _database
              .child(userId)
              .child('image')
              .child('url')
              .once())
              .value as String);
      return result;
    }
    return Stream.fromFuture(getFuture());
  }

  @override
  void updateUsername(String username) async {
    FirebaseUser user = await _auth.currentUser();
    await _database
        .child(user.uid)
        .child('username')
        .set(username);
    print('username has been changed: $username');
  }

  @override
  Stream<String> getUsername() {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      String result = ((await _database
          .child(userId)
          .child('username')
          .once())
          .value as String);
      result ??= 'empty';
      return result;
    }
    return Stream.fromFuture(getFuture());
  }

  @override
  Stream<String> getUserEmail() {
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
        String un = authResult.user.displayName;
        String up = authResult.user.photoUrl;
        await _firstUsernameUpload(user.userId, un);
        await _firstImageUpload(user.userId, up);
      }
      return user;
    }

    return Stream.fromFuture(getFbSignedInUser());
  }

  Future<bool>_firstUsernameUpload(String uId, String un) async {
    String username = (await _database
        .child(uId)
        .child('username')
        .once())
        .value as String;
    if (username == null || username == 'empty') {
    updateUsername(un);
    }
    return true;
  }

  Future<bool> _firstImageUpload(String uId, String imageURL) async {
    String url = (await _database
        .child(uId)
        .child('image')
        .child('url')
        .once())
        .value
    as String;
    if(url == null){
    _uploadProfilePicByURL(imageURL + '?height=500');
    }
    return true;
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
