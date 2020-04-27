import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/user_repository.dart';
import 'package:xhabits/src/domain/update_username_use_case.dart';

class SimpleUpdateUsernameUseCase implements UpdateUsernameUseCase {

  final UserRepository _repository;

  SimpleUpdateUsernameUseCase(this._repository);

  @override
  BehaviorSubject<bool> updateUsername(String username) => _repository.updateUsername(username);

  @override
  Stream<String> getUsername() => _repository.getUsername();
}