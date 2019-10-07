import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service.dart';
import 'package:xhabits/src/domain/database_habit_data_use_case.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_bloc.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_state.dart';

class HabitRow extends StatefulWidget {
  final String _habitId;
  final String title;
  final List<DateTime> checkedDays;
  final DateTime _startDate;
  final DateTime _endDate;
  final List<DateTime> _weekDays;

  const HabitRow(this._habitId, this.title, this.checkedDays, this._startDate,
      this._endDate, this._weekDays);

  @override
  _HabitRowState createState() => _HabitRowState(
      HabitBloc(
        title,
        checkedDays,
        _startDate,
        _endDate,
        DatabaseHabitDataUseCase(_habitId, FirebaseDatabaseService()),
      ),
      _weekDays);
}

class _HabitRowState extends State<HabitRow> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();
  final HabitBloc _habitBloc;
  final List<DateTime> _weekDays;
  Size _screenSize;

  _HabitRowState(this._habitBloc, this._weekDays);

  @override
  void initState() {
    _habitBloc.getHabitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<HabitState>(
        stream: _habitBloc.habitStateObservable,
        builder: (BuildContext context, AsyncSnapshot<HabitState> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          _screenSize = MediaQuery.of(context).size;

          _chartKey.currentState
              ?.updateData(_progressChartData(snapshot.data.progress));

          return buildUi(context, snapshot.data);
        },
      );

  Widget buildUi(BuildContext context, HabitState habitState) => Container(
        padding: EdgeInsets.symmetric(horizontal: _screenSize.width * 0.015),
        height: _screenSize.height * 0.08,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            _progressCircle(habitState.progress),
            _habitTitle(habitState.habitTitle),
            _marks(habitState.checkedDays, _weekDays),
          ],
        ),
      );

  Widget _progressCircle(double progress) => Container(
        margin: EdgeInsets.only(right: _screenSize.width * 0.01),
        child: AnimatedCircularChart(
          key: _chartKey,
          holeRadius: _screenSize.width * 0.008,
          size: Size.fromRadius(_screenSize.width * 0.05),
          initialChartData: _progressChartData(progress),
          chartType: CircularChartType.Radial,
          percentageValues: true,
        ),
      );

  List<CircularStackEntry> _progressChartData(double progress) => [
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              progress,
              Colors.green,
            ),
            CircularSegmentEntry(
              (100 - progress),
              Colors.grey[300],
            ),
          ],
          rankKey: 'progress',
        )
      ];

  Widget _habitTitle(String title) => Expanded(
        child: Container(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                fontSize: _screenSize.width * 0.043,
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w400),
          ),
        ),
      );

  Widget _marks(List<DateTime> checkedDays, List<DateTime> weekdays) =>
      Container(
        width: _screenSize.width * 0.5,
        margin: EdgeInsets.only(left: _screenSize.width * 0.1),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weekdays.length,
                  itemBuilder: (context, index) =>
                      _marksIcon(checkedDays, weekdays[index])),
            ),
          ],
        ),
      );

  Widget _marksIcon(List<DateTime> checkedDays, DateTime weekday) => Container(
        margin: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.025,
            vertical: _screenSize.height * 0.025),
        child: SizedBox(
          width: _screenSize.width * 0.054,
          child: IconButton(
            icon: _habitBloc.dayIsChecked(checkedDays, weekday)
                ? Icon(Icons.check, color: Colors.green)
                : Icon(Icons.close),
            padding: EdgeInsets.all(0.0),
            iconSize: _screenSize.width * 0.054,
            onPressed: () {
              _habitBloc.checkDay(weekday);
            },
          ),
        ),
      );
}
