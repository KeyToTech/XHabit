import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/habit_data_use_case.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_state.dart';

class HabitBloc {
  BehaviorSubject<HabitState> _habitStateSubject;

  Observable<HabitState> get habitStateObservable => _habitStateSubject.stream;

  HabitDataUseCase _useCase;

  HabitBloc(HabitDataUseCase useCase) {
    _habitStateSubject = BehaviorSubject<HabitState>();
    _useCase = useCase;
  }

  /*void initHabits() {
    _habitStateSubject.sink.add(HabitState(
        _useCase.habitTitle(), _useCase.checkedDays(), _useCase.progress()));
  }*/

  void getHabitData() {
    Observable.combineLatest2(_useCase.habitTitle(), _useCase.checkedDays(),
            ((title, checkedDays) => {title: checkedDays}))
        .listen(handleHabitData);
  }

  handleHabitData(Map<dynamic, dynamic> map) {
    _habitStateSubject.sink.add(HabitState(
      map.keys.first as String,
      map.values.first as List<DateTime>,
      _useCase.progress(),
    ));
  }

  bool dayIsChecked(List<DateTime> checkedDays, DateTime date) =>
      checkedDays.contains(date);
}
