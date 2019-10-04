import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';

class DatabaseHabitDataUseCase implements HabitDataUseCase {
  final DatabaseService _service;
  final String _habitId;

  DatabaseHabitDataUseCase(this._habitId, this._service);

  @override
  void updateCheckedDays(List<DateTime> checkedDays) =>
      _service.updateCheckedDays(_habitId, checkedDays);
}
