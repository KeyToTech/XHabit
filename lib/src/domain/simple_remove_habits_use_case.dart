import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/remove_habits_use_case.dart';

class SimpleRemoveHabitsUseCase implements RemoveHabitsUseCase {
  final DatabaseService _service;

  SimpleRemoveHabitsUseCase(this._service);

  @override
  void removeHabits(List<String> habitIds) => _service.removeHabits(habitIds);
}
