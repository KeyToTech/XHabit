import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';

class DatabaseHabitDataUseCase implements HabitDataUseCase {
  final DatabaseService _service;
  final String _habitId;

  DatabaseHabitDataUseCase(this._habitId, this._service);

  @override
  List<DateTime> checkedDays() {
    var data;
    List<DateTime> result;
    _service.getHabit(_habitId).then((snapshot) {
      data = snapshot.checkedDays;
      print('-USE CASE $_habitId- _service.getHabit() : $data');
    });
    print('-USE CASE $_habitId- AFTER _service.getHabit(): $data');
    for (String item in data) {
      result.add(DateTime.parse(item));
    }
    print('-USE CASE $_habitId- BEFORE RETURN: $result');
    return result;
  }

  @override
  String habitTitle() {
    String result;
    _service.getHabit(_habitId).then((snapshot) {
      result = snapshot.title as String;
    });

    return result;
  }

  @override
  double progress() => 60.0;

  @override
  bool isChecked(DateTime dateTime) => checkedDays().contains(dateTime);
}
