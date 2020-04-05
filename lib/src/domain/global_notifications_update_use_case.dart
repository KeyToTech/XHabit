import 'package:rxdart/rxdart.dart';

abstract class GlobalNotificationsUpdateUseCase {
  Stream<bool>updateGlobalNotifications(bool notificationsOn);
  BehaviorSubject<bool>getGlobalNotificationsStatus();
}