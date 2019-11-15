import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/remove_habit_use_case.dart';

class SimpleRemoveHabitUseCase implements RemoveHabitUseCase {
  final DatabaseService _service;

  SimpleRemoveHabitUseCase(this._service);

  @override
  void removeHabit(String habitId) => _service.removeHabit(habitId);
}
