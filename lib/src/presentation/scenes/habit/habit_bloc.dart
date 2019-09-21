import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_state.dart';

class HabitBloc {
  BehaviorSubject<HabitState> _habitStateSubject;

  Observable<HabitState> get habitStateObservable => _habitStateSubject.stream;

  String _title;
  List<DateTime> _checkedDays;

  HabitBloc(String title, List<DateTime> checkedDays) {
    _habitStateSubject = BehaviorSubject<HabitState>();
    _title = title;
    _checkedDays = checkedDays;
  }

  void getHabitData() {
    _habitStateSubject.sink.add(HabitState(_title, _checkedDays, 60.0));
  }

  bool dayIsChecked(List<DateTime> checkedDays, DateTime date) =>
      checkedDays.contains(date);
}
