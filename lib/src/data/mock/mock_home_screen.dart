import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit.dart';

class MockHomeScreenData {
  List<Habit> habitList = [
    Habit('one'),
    Habit('two'),
    Habit('A lot of textA lot of textA lot of textA lot of textA lot of text')
  ];

  List<Column> dayList = [
    Column(
      children: <Widget>[
        Text('Fri'),
        Text('23'),
      ],
    ),
    Column(
      children: <Widget>[
        Text('Thu'),
        Text('22'),
      ],
    ),
    Column(
      children: <Widget>[
        Text('Wed'),
        Text('21'),
      ],
    ),
    Column(
      children: <Widget>[
        Text('Tue'),
        Text('20'),
      ],
    ),
    Column(
      children: <Widget>[
        Text('Mon'),
        Text('19'),
      ],
    ),
    Column(
      children: <Widget>[
        Text('Sun'),
        Text('18'),
      ],
    ),
  ];
}
