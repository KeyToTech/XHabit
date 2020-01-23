import 'package:xhabits/src/domain/check_user_is_signed_use_case.dart';

class MockUserRepository implements CheckUserIsSignedInUseCase {
  @override
  Stream<bool> isUserSignedIn() => Stream.value(true);
}