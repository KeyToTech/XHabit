import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:xhabits/src/domain/simple_save_habit_use_case.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/save_habit_bloc.dart';

class SaveHabit extends StatefulWidget {
  final String _hint;
  Habit _selectedHabit;

  SaveHabit.create() : _hint = 'Create habit';

  SaveHabit.update(this._selectedHabit) : _hint = 'Edit habit';

  @override
  _SaveHabitState createState() => _SaveHabitState(SaveHabitBloc(_hint,
      _selectedHabit, SimpleCreateHabitUseCase(FirebaseDatabaseService())));
}

class _SaveHabitState extends State<SaveHabit> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  final SaveHabitBloc _saveHabitBloc;
  Size _screenSize;

  _SaveHabitState(this._saveHabitBloc) {
    _titleController = TextEditingController(text: _saveHabitBloc.title);
    _descriptionController =
        TextEditingController(text: _saveHabitBloc.description);
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
              _saveHabitBloc.saveHabit(
                  _titleController.text, _descriptionController.text);
            },
          )
        ],
      );

  Widget _body() => Container(
        padding: EdgeInsets.symmetric(
            vertical: _screenSize.height * 0.02,
            horizontal: _screenSize.width * 0.035),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              style: TextStyle(fontSize: _screenSize.height * 0.032),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: _screenSize.height * 0.032),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                style: TextStyle(fontSize: _screenSize.height * 0.032),
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(fontSize: _screenSize.height * 0.032),
                ),
                maxLines: null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                datePicker('Start date'),
                datePicker('End date'),
              ],
            )
          ],
        ),
      );

  FlatButton datePicker(String dateHint) => FlatButton(
        child: Text(
          dateHint,
          style: TextStyle(fontSize: _screenSize.height * 0.03),
        ),
        onPressed: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(1970, 1, 1),
            maxTime: DateTime(2030, 12, 31),
            onConfirm: (date) {
              if (dateHint == 'Start date') {
                _saveHabitBloc.setStartDate(date);
              } else {
                _saveHabitBloc.setEndDate(date);
              }
            },
            currentTime: _pickerCurrentTime(dateHint),
          );
        },
      );

  void _handleSaveHabit(bool onSaveHabit) {
    Navigator.of(context).pop();
  }

  DateTime _pickerCurrentTime(String dateHint) {
    if (dateHint == 'Start date') {
      return _saveHabitBloc.startDate ?? _dateTimeNow();
    } else {
      return _saveHabitBloc.endDate ?? _dateTimeNow();
    }
  }

  DateTime _dateTimeNow() => DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
