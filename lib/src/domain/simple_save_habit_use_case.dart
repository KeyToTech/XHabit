import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/save_habit_use_case.dart';

class SimpleCreateHabitUseCase implements CreateHabitUseCase {
  final DatabaseService _service;

  SimpleCreateHabitUseCase(this._service);

  @override
  Stream<bool> createHabit(String habitId, String title, enableNotification, String startDate,
          String endDate, {String notificationTime}) =>
      _service.createHabit(
          habitId, title, enableNotification, startDate, endDate, notificationTime: notificationTime);

  @override
  Stream<bool> updateHabit(
          String habitId,
          String title,
          bool enableNotification,
          String startDate,
          String endDate,
          List<DateTime> checkedDays,
          {String notificationTime}) =>
      _service.updateHabit(
          habitId, title, enableNotification, startDate, endDate, checkedDays, notificationTime: notificationTime,);
}
