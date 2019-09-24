import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service.dart';
import 'package:xhabits/src/domain/simple_create_habit_use_case.dart';
import 'package:xhabits/src/presentation/scenes/create_habit/create_habit_bloc.dart';

class CreateHabit extends StatefulWidget {
  @override
  _CreateHabitState createState() => _CreateHabitState(
      CreateHabitBloc(SimpleCreateHabitUseCase(FirebaseDatabaseService())));
}

class _CreateHabitState extends State<CreateHabit> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final CreateHabitBloc _createHabitBloc;
  Size _screenSize;

  _CreateHabitState(this._createHabitBloc);

  @override
  void initState() {
    _createHabitBloc.createHabitObservable.listen(_handleSaveHabit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() => AppBar(
        title: Text(
          'Create habit',
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
              _createHabitBloc.saveHabit(
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
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: _screenSize.height * 0.032),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _descriptionController,
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

  FlatButton datePicker(String hint) => FlatButton(
        child: Text(
          hint,
          style: TextStyle(fontSize: _screenSize.height * 0.03),
        ),
        onPressed: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(1970, 1, 1),
            maxTime: DateTime(2030, 12, 31),
            onConfirm: (date) {
              _createHabitBloc.endDate = date;
            },
            currentTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          );
        },
      );

  void _handleSaveHabit(bool onSaveHabit) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
