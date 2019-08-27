import 'package:flutter/material.dart';
import 'package:xhabits/src/data/home_repository.dart';
import 'package:xhabits/src/domain/simple_home_screen_data_use_case.dart';
import 'package:xhabits/src/presentation/scenes/habit/habit.dart';
import 'package:xhabits/src/presentation/scenes/home/habit_screen_state.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen_block.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState(
      HomeScreenBlock(SimpleHomeScreenUseCase(HomeRepository())));
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenBlock _homeScreenBlock;

  _HomeScreenState(this._homeScreenBlock);

  @override
  void initState() {
    _homeScreenBlock.init();
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
      child: StreamBuilder<HomeScreenResource>(
          stream: _homeScreenBlock.homeScreenStateObservable,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              final List<DateTime> days = snapshot.data.weekDays;

              return Column(children: <Widget>[
                Container(
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
                ),
                _habitsList([HabitRow(days), HabitRow(days), HabitRow(days)]),
              ]);
            }
          }));

  Widget _habitsList(List<HabitRow> habits) => Expanded(
        child: ListView.builder(
          itemCount: habits.length,
          itemBuilder: (BuildContext context, int index) => habits[index],
        ),
      );
}
