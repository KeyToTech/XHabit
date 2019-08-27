import 'package:flutter/material.dart';
import 'package:xhabits/src/data/mock/mock_habit.dart';
import 'package:xhabits/src/domain/simple_habit_data_use_case.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_bloc.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() =>
      _HomeScreenState(HabitBloc(SimpleHabitDataUseCase(MockHabitData())));
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Habit> _habits = [Habit(), Habit(), Habit()];

  final HabitBloc _habitBloc;

  _HomeScreenState(this._habitBloc);

  @override
  void initState() {
    _habitBloc.initHabits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: appBar(), body: body());

  PreferredSizeWidget appBar() => AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      );

  Widget body() => Container(
        color: Colors.grey[300],
        child: Column(
          children: <Widget>[
            _calendarItems(),
            _habitItems(),
          ],
        ),
      );

  Widget _calendarItems() => StreamBuilder<HabitState>(
      stream: _habitBloc.habitStateObservable,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();

        final List<DateTime> days = snapshot.data.weekDays;

        return Container(
          height: 50.0,
          padding: EdgeInsets.only(left: 210.0, right: 8.0, top: 9.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  itemBuilder: (context, index) => Container(
                    child: Column(
                      children: <Widget>[
                        Text(days[index].weekday.toString()),
                        Text(days[index].day.toString())
                      ],
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      });

  Widget _habitItems() => Expanded(
        child: ListView.builder(
          itemCount: _habits.length,
          itemBuilder: (BuildContext context, int index) => _habits[index],
        ),
      );
}
