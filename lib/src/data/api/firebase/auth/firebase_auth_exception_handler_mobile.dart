import 'package:flutter/services.dart';
import 'package:xhabits/src/data/api/auth_exception_handler.dart';

class FirebaseAuthExceptionHandlerMobile implements AuthExceptionHandler {
  @override
  String getErrorMessage(error) {
    var platformException = (error as PlatformException);
    return platformException.message;
  }
}
