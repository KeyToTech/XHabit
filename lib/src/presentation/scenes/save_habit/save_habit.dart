import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:xhabits/config/app_config.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/simple_save_habit_use_case.dart';
import 'package:xhabits/src/presentation/XHColors.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/save_habit_bloc.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/selected_dates.dart';
import 'package:xhabits/src/presentation/screen_type.dart';
import 'package:xhabits/src/presentation/widgets/xh_stateful_button.dart';

class SaveHabit extends StatefulWidget {
  final String _hint;
  Habit _selectedHabit;

  SaveHabit.create() : _hint = 'New habit';

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
        automaticallyImplyLeading: false,
        backgroundColor: XHColors.darkGrey,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.only(left: 0),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: _screenSize.height * 0.023),
              ),
              textColor: XHColors.pink,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              widget._hint,
              style: TextStyle(fontSize: _screenSize.height * 0.027),
            ),
            FlatButton(
              padding: EdgeInsets.only(right: 0),
              child: Text(
                'Save',
                style: TextStyle(fontSize: _screenSize.height * 0.023),
              ),
              textColor: XHColors.pink,
              onPressed: () {
                _saveHabitBloc.saveHabit(_titleController.text);
              },
            )
          ],
        ),
      );

  Widget _body() => Container(
        color: XHColors.darkGrey,
        padding: EdgeInsets.symmetric(
            vertical: _screenSize.height * 0.02,
            horizontal: _screenSize.width * 0.035),
        child: ListView(
          children: <Widget>[
            Text(
              'What do you want to accomplish?',
              style: TextStyle(
                fontSize: _screenSize.height * 0.03,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: _screenSize.height * 0.045),
              child: TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: _screenSize.height * 0.03,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  fillColor: XHColors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: 'Name your new habit',
                  hintStyle: TextStyle(
                    fontSize: _screenSize.height * 0.02,
                    color: XHColors.lightGrey,
                  ),
                ),
              ),
            ),
            _reminderRow(),
            _dateRow('Start date'),
            _dateRow('End date'),
            _notificationRow(),
          ],
        ),
      );

  Divider _pickersDivider() => Divider(
        color: Colors.black,
        thickness: _screenSize.shortestSide * 0.0015,
        height: _screenSize.height * 0.06,
      );

  Widget _reminderRow() => StreamBuilder<bool>(
        stream: _saveHabitBloc.enableNotificationObservable,
        builder: (context, snapshot) => Column(
          children: <Widget>[
            _pickersDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: ScreenType.large
                          ? _screenSize.width * 0.01
                          : _screenSize.width * 0.04),
                  child: Text('Set reminder',
                      style: TextStyle(
                        fontSize: _screenSize.height * 0.025,
                        color: Colors.white,
                      )),
                ),
                CupertinoSwitch(
                  activeColor: XHColors.pink,
                  value: _saveHabitBloc.enableNotification,
                  onChanged: (value) {
                    _saveHabitBloc.setEnableNotification(value);
                    _saveHabitBloc.switcherChanged();
                    if (value) {
                      _saveHabitBloc.notificationTime = '12:00';
                    } else {
                      _saveHabitBloc.notificationTime = null;
                    }
                    _saveHabitBloc.displayNotificationTime();
                  },
                )
              ],
            )
          ],
        ),
      );

  Widget _dateRow(String dateHint) => StreamBuilder<SelectedDates>(
        stream: _saveHabitBloc.selectedDatesObservable,
        builder: (context, snapshot) => Column(
          children: <Widget>[
            _pickersDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _datePicker(dateHint),
                _dateText(dateHint, snapshot.data ?? SelectedDates('', '')),
              ],
            ),
          ],
        ),
      );

  Widget _dateText(String dateHint, SelectedDates selectedDates) => Container(
        padding: EdgeInsets.only(right: _screenSize.width * 0.04),
        child: Text(
          dateHint == 'Start date'
              ? selectedDates.startDate
              : selectedDates.endDate,
          style: TextStyle(
            fontSize: _screenSize.height * 0.02,
            color: Colors.white,
          ),
        ),
      );

  FlatButton _datePicker(String dateHint) => FlatButton(
        child: Text(
          dateHint,
          style: TextStyle(
            fontSize: _screenSize.height * 0.025,
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          final DateTime date = await showRoundedDatePicker(
              context: context,
              initialDate: _saveHabitBloc.pickerCurrentDate(dateHint),
              firstDate: _saveHabitBloc.pickerFirstDate(dateHint),
              lastDate: DateTime(2030, 12, 31),
              theme: ThemeData(
                primarySwatch: Colors.pink,
                primaryColor: XHColors.darkGrey,
                accentColor: XHColors.pink,
                dialogBackgroundColor: XHColors.grey,
                textTheme: TextTheme(
                    body1: TextStyle(color: XHColors.lightGrey),
                    caption: TextStyle(color: XHColors.lightGrey)),
              ));

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
        builder: (context, snapshot) => Column(
          children: <Widget>[
            _pickersDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                XHStatefulButton(
                        'Reminder time',
                        _screenSize.height * 0.03,
                        _saveHabitBloc.enableNotification,
                        Colors.white,
                        XHColors.grey,
                        _onTimePicker)
                    .statefulButton(),
                Container(
                  padding: EdgeInsets.only(right: _screenSize.width * 0.04),
                  child: Text(
                    snapshot.data ?? '',
                    style: TextStyle(
                      fontSize: _screenSize.height * 0.02,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
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

  Theme _pickerTheme(Widget child) => Theme(
        data: ThemeData(
          primarySwatch: Colors.pink,
          primaryColor: XHColors.grey,
          accentColor: XHColors.pink,
          dialogBackgroundColor: Colors.grey,
        ),
        child: child,
      );

  void _handleSaveHabit(bool onSaveHabit) {
    Navigator.of(context).pop();
  }

  void _onTimePicker() async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: _selectedTime(),
      builder: (BuildContext context, Widget child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: _pickerTheme(child),
      ),
    );
    if (time != null) {
      _saveHabitBloc.setNotificationTime(time);
      _saveHabitBloc.displayNotificationTime();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _saveHabitBloc.dispose();
    super.dispose();
  }
}
