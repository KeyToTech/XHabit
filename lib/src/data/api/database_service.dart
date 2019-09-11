import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';

abstract class DatabaseService {
  Observable<String> getHabitTitle(String habitId);
  Observable<List<DateTime>> getHabitCheckedDays(String habitId);
  void createHabit(String habitId, String title);
  void removeHabit(String habitId);
}