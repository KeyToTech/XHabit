import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:xhabits/src/data/mock/mock_habit.dart';

class Habit extends StatefulWidget {
  final String _title;

  const Habit(this._title);

  @override
  _HabitState createState() => _HabitState();
}

class _HabitState extends State<Habit> {

  List<Icon> _iconList = MockIconList().iconList;

  @override
  Widget build(BuildContext context) => Container(
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
                    80.0,
                    Colors.green,
                  ),
                  CircularSegmentEntry(
                    20.0,
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
              widget._title,
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
                    itemCount: _iconList.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 7.6),
                      child: _iconList[index],
                    )),
              )
            ],
          ),
        )
      ],
    ),
  );
}
