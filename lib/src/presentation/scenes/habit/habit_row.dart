import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_bloc.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit_state.dart';

class HabitRow extends StatefulWidget {
  final String title;
  final List<DateTime> checkedDays;
  final bool isSelected;
  final List<DateTime> _weekDays;

  const HabitRow(this.title, this.checkedDays, this.isSelected, this._weekDays);

  @override
  _HabitRowState createState() =>
      _HabitRowState(HabitBloc(title, checkedDays), isSelected, _weekDays);
}

class _HabitRowState extends State<HabitRow> {
  final HabitBloc _habitBloc;
  bool _isSelected;
  final List<DateTime> _weekDays;
  Size _screenSize;

  _HabitRowState(this._habitBloc, this._isSelected, this._weekDays);

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
          return buildUi(context, snapshot.data);
        },
      );

  Widget buildUi(BuildContext context, HabitState habitState) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: _isSelected
              ? Border(
                  top: BorderSide(
                      color: Colors.black, width: _screenSize.height * 0.003),
                  bottom: BorderSide(
                      color: Colors.black, width: _screenSize.height * 0.003),
                )
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: _screenSize.width * 0.015),
        margin: EdgeInsets.only(bottom: _screenSize.height * 0.005),
        height: _screenSize.height * 0.08,
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
          holeRadius: _screenSize.width * 0.008,
          size: Size.fromRadius(_screenSize.width * 0.05),
          initialChartData: <CircularStackEntry>[
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
            ),
          ],
          chartType: CircularChartType.Radial,
          percentageValues: true,
        ),
      );

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
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: _screenSize.width * 0.025),
                  child: _habitBloc.dayIsChecked(checkedDays, weekdays[index])
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                          size: _screenSize.width * 0.054,
                        )
                      : Icon(
                          Icons.close,
                          size: _screenSize.width * 0.054,
                        ),
                ),
              ),
            ),
          ],
        ),
      );
}
