import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';

class DatabaseHabitDataUseCase implements HabitDataUseCase {
  final DatabaseService _service;
  final String _habitId;

  DatabaseHabitDataUseCase(this._habitId, this._service);

  @override
  Observable<List<DateTime>> checkedDays() =>
      _service.getHabitCheckedDays(_habitId);

  @override
  Observable<String> habitTitle() => _service.getHabitTitle(_habitId);

  @override
  double progress() => 60.0;
}
