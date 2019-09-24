import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/create_habit_use_case.dart';

class CreateHabitBloc {
  DateTime startDate;
  DateTime endDate;

  BehaviorSubject<bool> _createHabitSubject;

  Observable<bool> get createHabitObservable => _createHabitSubject.stream;
  CreateHabitUseCase _useCase;

  CreateHabitBloc(CreateHabitUseCase useCase) {
    _createHabitSubject = BehaviorSubject<bool>();
    _useCase = useCase;
  }

  void saveHabit(
      String title, String description) {
      if (title != null &&
        description != null &&
        startDate != null &&
        endDate != null) {
      _useCase
          .createHabit(DateTime.now().toString().split('.')[0], title,
              description, startDate.toString(), endDate.toString())
          .listen(_onSaveHabit);
    }
  }

  void _onSaveHabit(bool onSaveHabit) {
    _createHabitSubject.sink.add(onSaveHabit);
  }
}
