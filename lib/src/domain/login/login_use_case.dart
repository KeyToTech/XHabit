import 'package:xhabits/src/data/api/firebase/firebase_auth_service.dart';
import 'package:xhabits/src/data/entities/user.dart';
import 'package:rxdart/rxdart.dart';

class LoginUseCase {
  final String email;
  final String password;
  FirebaseAuthService firebaseAuthService;

  LoginUseCase(this.email, this.password) {
    firebaseAuthService = FirebaseAuthService();
  }

  Observable<User> login() {
    return firebaseAuthService.signIn(email, password);
  }
}
