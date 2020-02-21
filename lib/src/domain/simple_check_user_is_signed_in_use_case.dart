import 'package:xhabits/src/data/api/auth_service.dart';

import 'check_user_is_signed_use_case.dart';

class SimpleCheckUserIsSignedInUseCase implements CheckUserIsSignedInUseCase {
  final AuthService _service;

  SimpleCheckUserIsSignedInUseCase(this._service);

  @override
  Stream<bool> isUserSignedIn() => _service.isSignedIn();
}