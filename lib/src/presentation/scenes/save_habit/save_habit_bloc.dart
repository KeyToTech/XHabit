import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/save_habit_use_case.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/selected_dates.dart';

class SaveHabitBloc {
  final String _hint;
  String habitId;
  String title;
  bool enableNotification;
  String description;
  DateTime startDate;
  DateTime endDate;
  String notificationTime;
  List<DateTime> checkedDays;

  BehaviorSubject<bool> _saveHabitSubject;
  BehaviorSubject<bool> _enableNotificationSubject;
  BehaviorSubject<SelectedDates> _selectedDatesSubject;
  BehaviorSubject<String> _notificationTimeSubject;

  bool get dataEntered =>
      title != null ||
      notificationTime != null ||
      startDate != null ||
      endDate != null;

  Stream<bool> get saveHabitObservable => _saveHabitSubject.stream;

  Stream<SelectedDates> get selectedDatesObservable =>
      _selectedDatesSubject.stream;

  Stream<String> get notificationTimeObservable =>
      _notificationTimeSubject.stream;

  Stream<bool> get enableNotificationObservable =>
      _enableNotificationSubject.stream;

  CreateHabitUseCase _useCase;

  SaveHabitBloc(this._hint, Habit selectedHabit, CreateHabitUseCase useCase) {
    habitId = selectedHabit?.habitId;
    title = selectedHabit?.title;
    if (selectedHabit?.enableNotification != null) {
      enableNotification = selectedHabit?.enableNotification;
    } else {
      enableNotification = false;
    }
    startDate = selectedHabit?.startDate ?? DateTime.now();
    endDate = selectedHabit?.endDate;
    notificationTime = selectedHabit?.notificationTime;
    checkedDays = selectedHabit?.checkedDays;
    _saveHabitSubject = BehaviorSubject<bool>();
    _enableNotificationSubject =
        BehaviorSubject<bool>.seeded(enableNotification);
    _selectedDatesSubject = BehaviorSubject<SelectedDates>.seeded(
        SelectedDates(_dateString(startDate), _dateString(endDate)));
    _notificationTimeSubject = BehaviorSubject<String>.seeded(notificationTime);
    _useCase = useCase;
  }

  String saveHabit(String title) {
    String message = _validationMessage(title, startDate, endDate);
    if (message == null) {
      if (_hint == 'New habit') {
        _useCase
            .createHabit(
              DateTime.now().toString().split('.')[0],
              title,
              enableNotification,
              startDate.toString(),
              endDate: endDate.toString(),
              notificationTime: notificationTime,
            )
            .listen(_onSaveHabit);
      } else {
        _useCase
            .updateHabit(
              habitId,
              title,
              enableNotification,
              startDate.toString(),
              checkedDays,
              endDate: endDate.toString(),
              notificationTime: notificationTime,
            )
            .listen(_onSaveHabit);
      }
    }
    return message;
  }

  void setStartDate(DateTime date) {
    startDate = date;
    if (endDate != null && startDate.compareTo(endDate) >= 0) {
      endDate = startDate.add(Duration(days: 1));
    }
  }

  void setEndDate(DateTime date) => endDate = date;

  void setNotificationTime(TimeOfDay time) => notificationTime =
      '${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}';

  void setEnableNotification(bool value) => enableNotification = value;

  String _validationMessage(
      String title, DateTime startDate, DateTime endDate) {
    String message;
    if (title == null || title.isEmpty) {
      message = "Title can't be empty.";
    } else if (startDate == null) {
      message = 'Please, select start date.';
    }
    return message;
  }

  void _onSaveHabit(bool onSaveHabit) {
    _saveHabitSubject.sink.add(onSaveHabit);
  }

  void displaySelectedDates() {
    _selectedDatesSubject.sink
        .add(SelectedDates(_dateString(startDate), _dateString(endDate)));
  }

  void switcherChanged() {
    _enableNotificationSubject.sink.add(enableNotification);
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
      if (startDate != null && startDate.isBefore(_dateTimeNow())) {
        return startDate;
      } else {
        return _dateTimeNow();
      }
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
