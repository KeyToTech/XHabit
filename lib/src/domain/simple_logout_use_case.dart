import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';

class SimpleLogoutUseCase extends LogoutUseCase {
  final UserRepository _repository;

  SimpleLogoutUseCase(this._repository);

  @override
  Stream<bool> logout() => _repository.logout();
}
