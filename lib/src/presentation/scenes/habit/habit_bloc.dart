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
    print('BLOC START getHabitData()');
    Observable.combineLatest(
        [_useCase.habitTitle(), _useCase.checkedDays()], handleHabitData);
    //_useCase.habitTitle().listen(handleHabitData);
    print('BLOC END getHabitData()');
  }

  handleHabitData(List<Object> values) {
    print('BLOC START handleHabitData');
    print('values[0]: ${values[0]}\nvalues[1]: ${values[1]}');
    _habitStateSubject.sink.add(HabitState(
        values[0] as String,
        values[1] as List<DateTime>,
        _useCase.progress()));
    print('BLOC END handleHabitData');
  }

  bool dayIsChecked(DateTime date) => _useCase.isChecked(date);
}
