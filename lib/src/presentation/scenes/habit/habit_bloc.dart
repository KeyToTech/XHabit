import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_state.dart';

class HabitBloc {
  BehaviorSubject<HabitState> _habitStateSubject;

  Stream<HabitState> get habitStateObservable => _habitStateSubject.stream;

  HabitDataUseCase _useCase;

  String _title;
  List<DateTime> _checkedDays;
  DateTime _startDate;
  DateTime _endDate;

  HabitBloc(String title, List<DateTime> checkedDays, DateTime startDate,
      DateTime endDate, HabitDataUseCase useCase) {
    _habitStateSubject = BehaviorSubject<HabitState>();
    _title = title;
    _checkedDays = checkedDays;
    _startDate = startDate;
    _endDate = endDate;
    _useCase = useCase;
  }

  void getHabitData() {
    _habitStateSubject.sink.add(HabitState(_title, _checkedDays, _progress()));
  }

  void checkDay(DateTime day) {
    if (dayIsChecked(_checkedDays, day)) {
      _checkedDays.remove(day);
    } else {
      _checkedDays.add(day);
    }
    _useCase.updateCheckedDays(_checkedDays);
    getHabitData();
  }

  bool dayIsChecked(List<DateTime> checkedDays, DateTime date) =>
      checkedDays.contains(date);

  bool showCheckIcon(DateTime date) =>
      date.compareTo(_startDate) >= 0 && date.compareTo(_endDate) <= 0;

  double _progress() =>
      (_checkedDays.length / _endDate.difference(_startDate).inDays) * 100;
}
