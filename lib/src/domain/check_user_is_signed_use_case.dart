import 'package:rxdart/rxdart.dart';

abstract class CheckUserIsSignedInUseCase {
  Observable<bool> isUserSignedIn();
}