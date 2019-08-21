import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/check_user_is_signed_use_case.dart';

class MockUserRepository implements CheckUserIsSignedInUseCase {
  @override
  Observable<bool> isUserSignedIn() {
    return Observable.just(true);
  }
}