import 'package:xhabits/src/data/user_repository.dart';

import 'check_user_is_signed_use_case.dart';

class SimpleCheckUserIsSignedInUseCase implements CheckUserIsSignedInUseCase {
  final UserRepository _repository;

  SimpleCheckUserIsSignedInUseCase(this._repository);

  @override
  Stream<bool> isUserSignedIn() => _repository.isSignedIn();
}