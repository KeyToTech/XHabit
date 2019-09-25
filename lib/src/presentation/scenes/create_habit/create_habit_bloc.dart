import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/domain/create_habit_use_case.dart';

class CreateHabitBloc {
  DateTime _startDate;
  DateTime _endDate;

  BehaviorSubject<bool> _createHabitSubject;

  Observable<bool> get createHabitObservable => _createHabitSubject.stream;
  CreateHabitUseCase _useCase;

  CreateHabitBloc(CreateHabitUseCase useCase) {
    _createHabitSubject = BehaviorSubject<bool>();
    _useCase = useCase;
  }

  void saveHabit(String title, String description) {
    if (_validate(title, description, _startDate, _endDate)) {
      _useCase
          .createHabit(DateTime.now().toString().split('.')[0], title,
              description, _startDate.toString(), _endDate.toString())
          .listen(_onSaveHabit);
    }
  }

  void setStartDate(DateTime date) => _startDate = date;

  void setEndDate(DateTime date) => _endDate = date;

  bool _validate(String title, String description, DateTime startDate,
          DateTime endDate) =>
      title != null &&
      title.isNotEmpty &&
      description != null &&
      description.isNotEmpty &&
      startDate != null &&
      endDate != null;

  void _onSaveHabit(bool onSaveHabit) {
    _createHabitSubject.sink.add(onSaveHabit);
  }
}
