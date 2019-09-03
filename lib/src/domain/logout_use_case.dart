import 'package:rxdart/rxdart.dart';

abstract class LogoutUseCase {
  Observable<bool> logout();
}
