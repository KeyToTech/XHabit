import 'package:firebase/firebase.dart';
import 'package:xhabits/src/data/api/auth_exception_handler.dart';

class FirebaseAuthExceptionHandlerWeb implements AuthExceptionHandler {
  @override
  String getErrorMessage(error) {
    var firebaseError = (error as FirebaseError);
    return firebaseError.message;
  }
}
