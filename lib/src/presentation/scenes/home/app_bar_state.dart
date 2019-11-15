import 'package:xhabits/src/data/entities/habit.dart';

class AppBarState {
  final bool showEditingAppBar;
  final Habit selectedHabit;

  AppBarState(this.showEditingAppBar, this.selectedHabit);
}