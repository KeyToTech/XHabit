import 'package:xhabits/src/data/entities/user.dart';
import 'package:xhabits/src/data/user_repository.dart';

class FacebookLoginUseCase {
  final UserRepository _repository;

  FacebookLoginUseCase(this._repository);

  Stream<User> login() => _repository.loginWithFacebook();
}
