import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:xhabits/src/data/mock/mock_habit.dart';
import 'package:xhabits/src/domain/simple_habit_data_use_case.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_bloc.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_state.dart';

class Habit extends StatefulWidget {
  @override
  _HabitState createState() =>
      _HabitState(HabitBloc(SimpleHabitDataUseCase(MockHabitData())));
}

class _HabitState extends State<Habit> {
  final HabitBloc _habitBloc;

  _HabitState(this._habitBloc);

  @override
  void initState() {
    _habitBloc.initHabits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<HabitState>(
        stream: _habitBloc.habitStateObservable,
        builder: (BuildContext context, AsyncSnapshot<HabitState> snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          return buildUi(context, snapshot.data);
        },
      );

  Widget buildUi(BuildContext context, HabitState habitState) => Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 10.0),
        color: Colors.white,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 7.0),
              child: AnimatedCircularChart(
                holeRadius: 3.0,
                size: Size.fromRadius(15.0),
                initialChartData: <CircularStackEntry>[
                  CircularStackEntry(
                    <CircularSegmentEntry>[
                      CircularSegmentEntry(
                        60.0,
                        Colors.green,
                      ),
                      CircularSegmentEntry(
                        40.0,
                        Colors.grey[300],
                      ),
                    ],
                    rankKey: 'progress',
                  ),
                ],
                chartType: CircularChartType.Radial,
                percentageValues: true,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 50.0),
                child: Text(
                  habitState.habitTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            Container(
              width: 190.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: habitState.weekDays.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 7.6),
                        child: _habitBloc.dayIsChecked(index)
                            ? Icon(Icons.check, color: Colors.green)
                            : Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
