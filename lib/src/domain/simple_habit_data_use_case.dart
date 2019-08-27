import 'package:xhabits/src/data/mock/mock_habit.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';

class SimpleHabitDataUseCase implements HabitDataUseCase {
  final MockHabitData _habitData;

  SimpleHabitDataUseCase(this._habitData);

  @override
  List<DateTime> checkedDays() => _habitData.checkedDays;

  @override
  String habitTitle() => _habitData.title;

  @override
  List<DateTime> weekDays() => _habitData.weekDays;

  @override
  double progress() => 60.0;
}
