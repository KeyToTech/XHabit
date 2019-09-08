import 'package:xhabits/src/data/entities/habit.dart';

abstract class DatabaseService {
  Future<Habit> getHabit(String habitId);
  void createHabit(String habitId, String title);
  void removeHabit(String habitId);
}