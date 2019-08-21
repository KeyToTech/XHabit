
import 'package:xhabits/src/domain/splash_screen_use_case.dart';

class MockUserRepository implements SplashScreenUseCase {
  @override
  bool isUserSignedIn() {
    // TODO: implement isUserSignedIn
    return true;
  }

}