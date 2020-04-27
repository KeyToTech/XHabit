import 'package:rxdart/rxdart.dart';

abstract class UpdateUsernameUseCase {

  BehaviorSubject<bool> updateUsername(String userName);

  Stream<String> getUsername();

}