import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';

class DatabaseHabitDataUseCase implements HabitDataUseCase {
  final DatabaseService _service;
  final String _habitId;

  DatabaseHabitDataUseCase(this._habitId, this._service);

  @override
  Observable<List<DateTime>> checkedDays() =>
      null;

  @override
  Observable<String> habitTitle() => null;

  @override
  double progress() => 60.0;
}
