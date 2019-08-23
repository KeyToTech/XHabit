import 'package:flutter/material.dart';
import 'package:xhabits/src/data/mock/mock_habit.dart';
import 'package:xhabits/src/data/mock/mock_home_screen.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Habit> _habitList = MockHomeScreenData().habitList;
  List<Column> _dayList= MockHomeScreenData().dayList;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
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
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          children: <Widget>[
            Container(
              height: 50.0,
              padding: EdgeInsets.only(left: 218.0, right: 8.0, top: 9.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _dayList.length,
                      itemBuilder: (context, index) => Container(
                        child: _dayList[index],
                        margin: EdgeInsets.symmetric(horizontal: 7.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _habitList.length,
                itemBuilder: (BuildContext context, int index) =>
                _habitList[index],
              ),
            ),
          ],
        ),
      ));
}
