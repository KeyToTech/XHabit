import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/save_habit_use_case.dart';

class SimpleCreateHabitUseCase implements CreateHabitUseCase {
  final DatabaseService _service;

  SimpleCreateHabitUseCase(this._service);

  @override
  Stream<bool> createHabit(String habitId, String title, String description,
          String startDate, String endDate, String notificationTime) =>
      _service.createHabit(habitId, title, description, startDate, endDate, notificationTime);

  @override
  Stream<bool> updateHabit(String habitId, String title, String description,
      String startDate, String endDate,String notificationTime) =>
      _service.updateHabit(habitId, title, description, startDate, endDate, notificationTime);
}
