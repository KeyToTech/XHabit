import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/user.dart';

abstract class AuthService {
 Observable<User> signIn(String email, String password);
 Observable<bool> isSignedIn();
}