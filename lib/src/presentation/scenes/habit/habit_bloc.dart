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

  void initHabits() {
    _habitStateSubject.sink.add(HabitState(_useCase.habitTitle(),
        _useCase.checkedDays(), _useCase.weekDays(), _useCase.progress()));
  }

  bool dayIsChecked(int index) =>
      _useCase.checkedDays().contains(_useCase.weekDays()[index]);
}
