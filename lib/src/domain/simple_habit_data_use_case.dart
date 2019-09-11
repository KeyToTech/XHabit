import 'package:rxdart/src/observables/observable.dart';
import 'package:xhabits/src/data/mock/mock_habit.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';

class SimpleHabitDataUseCase implements HabitDataUseCase {
  final MockHabitData _habitData;

  SimpleHabitDataUseCase(this._habitData);

  /*@override
  List<DateTime> checkedDays() => _habitData.checkedDays;

  @override
  String habitTitle() => _habitData.title;*/

  @override
  double progress() => 60.0;

 /* @override
  bool isChecked(DateTime dateTime) => checkedDays().contains(dateTime);*/

  @override
  Observable<List<DateTime>> checkedDays() {
    // TODO: implement checkedDays
    return null;
  }

  @override
  Observable<String> habitTitle() {
    // TODO: implement habitTitle
    return null;
  }

  @override
  bool isChecked(DateTime dateTime) {
    // TODO: implement isChecked
    return null;
  }
}
