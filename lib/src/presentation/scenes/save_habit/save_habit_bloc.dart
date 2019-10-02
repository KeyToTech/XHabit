import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/save_habit_use_case.dart';

class SaveHabitBloc {
  final String _hint;
  String habitId;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;

  BehaviorSubject<bool> _saveHabitSubject;

  Observable<bool> get saveHabitObservable => _saveHabitSubject.stream;
  CreateHabitUseCase _useCase;

  SaveHabitBloc(this._hint, Habit selectedHabit, CreateHabitUseCase useCase) {
    habitId = selectedHabit?.habitId;
    title = selectedHabit?.title;
    description = selectedHabit?.description;
    startDate = selectedHabit?.startDate;
    endDate = selectedHabit?.endDate;
    _saveHabitSubject = BehaviorSubject<bool>();
    _useCase = useCase;
  }

  void saveHabit(String title, String description) {
    if (_validate(title, description, startDate, endDate)) {
      if (_hint == 'Create habit') {
        _useCase
            .createHabit(DateTime.now().toString().split('.')[0], title,
                description, startDate.toString(), endDate.toString())
            .listen(_onSaveHabit);
      } else {
        _useCase
            .updateHabit(habitId, title, description, startDate.toString(),
                endDate.toString())
            .listen(_onSaveHabit);
      }
    }
  }

  void setStartDate(DateTime date) => startDate = date;

  void setEndDate(DateTime date) => endDate = date;

  bool _validate(String title, String description, DateTime startDate,
          DateTime endDate) =>
      title != null &&
      title.isNotEmpty &&
      description != null &&
      description.isNotEmpty &&
      startDate != null &&
      endDate != null;

  void _onSaveHabit(bool onSaveHabit) {
    _saveHabitSubject.sink.add(onSaveHabit);
  }
}
