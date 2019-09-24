import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/create_habit_use_case.dart';

class SimpleCreateHabitUseCase implements CreateHabitUseCase {
  final DatabaseService _service;

  SimpleCreateHabitUseCase(this._service);

  @override
  Observable<bool> createHabit(String habitId, String title, String description,
          String startDate, String endDate) =>
      _service.createHabit(habitId, title, description, startDate, endDate);
}
