import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';

class DatabaseHomeScreenUseCase extends HomeScreenUseCase {
  HomeRepository _repository;

  DatabaseHomeScreenUseCase(this._repository);

  @override
  List<DateTime> weekDays() => _repository.weekDays();

  @override
  Observable<List<Habit>> getHabits() => _repository.getHabits();
}
