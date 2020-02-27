import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/home_screen_use_case.dart';

class SimpleHomeScreenUseCase extends HomeScreenUseCase {
  final HomeRepository _homeRepository;

  SimpleHomeScreenUseCase(this._homeRepository);

  @override
  List<DateTime> weekDays(List<Habit> habits) =>
      _homeRepository.weekDays(habits);

  @override
  Stream<List<Habit>> getHabits() => _homeRepository.getHabits();
}
