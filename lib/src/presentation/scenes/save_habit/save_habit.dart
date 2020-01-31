import 'package:flutter/material.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/simple_save_habit_use_case.dart';
import 'package:xhabits/src/presentation/XHColors.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/save_habit_bloc.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/selected_dates.dart';

class SaveHabit extends StatefulWidget {
  final String _hint;
  Habit _selectedHabit;

  SaveHabit.create() : _hint = 'Create habit';

  SaveHabit.update(this._selectedHabit) : _hint = 'Edit habit';

  @override
  _SaveHabitState createState() => _SaveHabitState(SaveHabitBloc(
      _hint, _selectedHabit, SimpleCreateHabitUseCase(AppConfig.database)));
}

class _SaveHabitState extends State<SaveHabit> {
  TextEditingController _titleController;

  final SaveHabitBloc _saveHabitBloc;
  Size _screenSize;

  _SaveHabitState(this._saveHabitBloc) {
    _titleController = TextEditingController(text: _saveHabitBloc.title);
  }

  @override
  void initState() {
    _saveHabitBloc.saveHabitObservable.listen(_handleSaveHabit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() => AppBar(
        title: Text(
          widget._hint,
          style: TextStyle(fontSize: _screenSize.height * 0.03),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: _screenSize.height * 0.027),
            ),
            textColor: Colors.white,
            onPressed: () {
              _saveHabitBloc.saveHabit(_titleController.text);
            },
          )
        ],
      );

  Widget _body() => Padding(
        padding: EdgeInsets.symmetric(
            vertical: _screenSize.height * 0.02,
            horizontal: _screenSize.width * 0.035),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextField(
              controller: _titleController,
              style: TextStyle(fontSize: _screenSize.height * 0.032),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: _screenSize.height * 0.032),
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    dateColumn('Start date'),
                    dateColumn('End date'),
                  ],
                ),
                _notificationRow(),
              ],
            ),
          ],
        ),
      );

  Widget dateColumn(String dateHint) => StreamBuilder<SelectedDates>(
      stream: _saveHabitBloc.selectedDatesObservable,
      builder: (context, snapshot) => Column(
            children: <Widget>[
              _dateText(dateHint, snapshot.data ?? SelectedDates('', '')),
              _datePicker(dateHint),
            ],
          ));

  Text _dateText(String dateHint, SelectedDates selectedDates) => Text(
        dateHint == 'Start date'
            ? selectedDates.startDate
            : selectedDates.endDate,
        style: TextStyle(fontSize: _screenSize.height * 0.035),
      );

  FlatButton _datePicker(String dateHint) => FlatButton(
        child: Text(
          dateHint,
          style: TextStyle(
              fontSize: _screenSize.height * 0.03),
        ),
        onPressed: () async {
          final DateTime date = await showDatePicker(
            context: context,
            initialDate: _saveHabitBloc.pickerCurrentDate(dateHint),
            firstDate: _saveHabitBloc.pickerFirstDate(dateHint),
            lastDate: DateTime(2030, 12, 31),
            builder: (BuildContext context, Widget child) => Theme(
              data: ThemeData(
                  primarySwatch: Colors.pink, //OK/Cancel button text color
                  primaryColor: XHColors.grey, //Head background
                  accentColor: XHColors.pink, //selection color
                  dialogBackgroundColor: Colors.grey, //Background color
//                buttonTheme: ButtonThemeData(
//                  buttonColor: XHColors.pink),
                ),
              child: child,
            ),
          );

          if (date != null) {
            if (dateHint == 'Start date') {
              _saveHabitBloc.setStartDate(date);
            } else {
              _saveHabitBloc.setEndDate(date);
            }
            _saveHabitBloc.displaySelectedDates();
          }
        },
      );

  Widget _notificationRow() => StreamBuilder<String>(
        stream: _saveHabitBloc.notificationTimeObservable,
        builder: (context, snapshot) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _timePicker(),
            Text(
              snapshot.data ?? '',
              style: TextStyle(fontSize: _screenSize.height * 0.05),
            ),
          ],
        ),
      );

  Widget _timePicker() => Container(
        margin: EdgeInsets.symmetric(vertical: _screenSize.height * 0.01),
        width: _screenSize.width * 0.18,
        height: _screenSize.height * 0.1,
        child: IconButton(
          icon: Icon(Icons.alarm, size: _screenSize.shortestSide * 0.1),
          onPressed: () async {
            final TimeOfDay time = await showTimePicker(
              context: context,
              initialTime: _selectedTime(),
              builder: (BuildContext context, Widget child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              ),
            );
            if (time != null) _saveHabitBloc.setNotificationTime(time);
            _saveHabitBloc.displayNotificationTime();
          },
        ),
      );

  TimeOfDay _selectedTime() {
    List<String> timeStrings = _saveHabitBloc.notificationTime?.split(':');
    if (timeStrings != null) {
      return TimeOfDay(
          hour: int.parse(timeStrings[0]), minute: int.parse(timeStrings[1]));
    } else {
      return TimeOfDay.now();
    }
  }

  void _handleSaveHabit(bool onSaveHabit) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _saveHabitBloc.dispose();
    super.dispose();
  }
}
