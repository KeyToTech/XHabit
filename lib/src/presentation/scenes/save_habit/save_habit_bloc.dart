import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/save_habit_use_case.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/selected_dates.dart';

class SaveHabitBloc {
  final String _hint;
  String habitId;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  String notificationTime;
  List<DateTime> checkedDays;

  BehaviorSubject<bool> _saveHabitSubject;
  BehaviorSubject<SelectedDates> _selectedDatesSubject;
  BehaviorSubject<String> _notificationTimeSubject;

  Stream<bool> get saveHabitObservable => _saveHabitSubject.stream;

  Stream<SelectedDates> get selectedDatesObservable =>
      _selectedDatesSubject.stream;

  Stream<String> get notificationTimeObservable =>
      _notificationTimeSubject.stream;

  CreateHabitUseCase _useCase;

  SaveHabitBloc(this._hint, Habit selectedHabit, CreateHabitUseCase useCase) {
    habitId = selectedHabit?.habitId;
    title = selectedHabit?.title;
    startDate = selectedHabit?.startDate;
    endDate = selectedHabit?.endDate;
    notificationTime = selectedHabit?.notificationTime;
    checkedDays = selectedHabit?.checkedDays;
    _saveHabitSubject = BehaviorSubject<bool>();
    _selectedDatesSubject = BehaviorSubject<SelectedDates>.seeded(
        SelectedDates(_dateString(startDate), _dateString(endDate)));
    _notificationTimeSubject = BehaviorSubject<String>.seeded(notificationTime);
    _useCase = useCase;
  }

  void saveHabit(String title) {
    if (_validate(title, startDate, endDate, notificationTime)) {
      if (_hint == 'Create habit') {
        _useCase
            .createHabit(
                DateTime.now().toString().split('.')[0],
                title,
                startDate.toString(),
                endDate.toString(),
                notificationTime)
            .listen(_onSaveHabit);
      } else {
        _useCase
            .updateHabit(
              habitId,
              title,
              startDate.toString(),
              endDate.toString(),
              notificationTime,
              checkedDays
            )
            .listen(_onSaveHabit);
      }
    }
  }

  void setStartDate(DateTime date) {
    startDate = date;
    if (endDate != null && startDate.compareTo(endDate) >= 0) {
      endDate = startDate.add(Duration(days: 1));
    }
  }

  void setEndDate(DateTime date) => endDate = date;

  void setNotificationTime(TimeOfDay time) =>
      notificationTime = '${time.hour}:${time.minute}';

  bool _validate(String title, DateTime startDate, DateTime endDate,
          String notificationTime) =>
      title != null &&
      title.isNotEmpty &&
      startDate != null &&
      endDate != null &&
      notificationTime != null;

  void _onSaveHabit(bool onSaveHabit) {
    _saveHabitSubject.sink.add(onSaveHabit);
  }

  void displaySelectedDates() {
    _selectedDatesSubject.sink
        .add(SelectedDates(_dateString(startDate), _dateString(endDate)));
  }

  void displayNotificationTime() {
    _notificationTimeSubject.sink.add(notificationTime);
  }

  String _dateString(DateTime date) =>
      date?.toString()?.split(' ')?.first ?? '';

  DateTime pickerCurrentDate(String dateHint) {
    if (dateHint == 'Start date') {
      return startDate ?? _dateTimeNow();
    } else {
      return endDate ?? pickerFirstDate('End date');
    }
  }

  DateTime pickerFirstDate(String dateHint) {
    if (dateHint == 'Start date') {
      return _dateTimeNow();
    } else {
      DateTime currentStartDate = startDate ?? _dateTimeNow();
      return currentStartDate.add(Duration(days: 1));
    }
  }

  DateTime _dateTimeNow() => DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

  void dispose() {
    _saveHabitSubject.close();
    _selectedDatesSubject.close();
    _notificationTimeSubject.close();
  }
}
