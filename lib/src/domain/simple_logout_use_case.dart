import 'package:xhabits/src/data/api/auth_service.dart';
import 'package:xhabits/src/domain/logout_use_case.dart';

class SimpleLogoutUseCase extends LogoutUseCase {
  final AuthService _authService;

  SimpleLogoutUseCase(this._authService);

  @override
  Stream<bool> logout() => _authService.logout();
}
