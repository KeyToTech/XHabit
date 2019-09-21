import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';

abstract class DatabaseService {
  Observable<List<Habit>> getHabits();
  void createHabit(String habitId, String title);
  void removeHabit(String habitId);
}