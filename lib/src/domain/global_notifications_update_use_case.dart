abstract class GlobalNotificationsUpdateUseCase {
  Stream<bool>updateGlobalNotifications(bool notificationsOn);
  Stream<bool>getGlobalNotificationsStatus();
}