import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/domain/check_user_is_signed_use_case.dart';

class UserRepository {
  final CheckUserIsSignedInUseCase _useCase;

  UserRepository(this._useCase);

  bool isUserSignedIn() {
    // TODO: implement isUserSignedIn https://trello.com/c/RF95DP0n/37-implement-isusersignedin
    return true;
  }
}