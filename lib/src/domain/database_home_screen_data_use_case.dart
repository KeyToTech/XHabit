import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';

class DatabaseHomeScreenUseCase extends HomeScreenUseCase {
  final HomeRepository _repository;

  DatabaseHomeScreenUseCase(this._repository);

  @override
  List<DateTime> weekDays() => _repository.weekDays();

  @override
  Stream<List<Habit>> getHabits() => _repository.getHabits();
}
