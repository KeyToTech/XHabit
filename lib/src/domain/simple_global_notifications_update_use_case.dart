import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/global_notifications_update_use_case.dart';

class SimpleGlobalNotificationsUpdateUseCase implements GlobalNotificationsUpdateUseCase {

  final DatabaseService _service;

  SimpleGlobalNotificationsUpdateUseCase(this._service);

  @override
  Stream<bool> updateGlobalNotifications(bool notificationsOn) => _service.updateGlobalNotifications(notificationsOn);

}