import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/home/base_screen_bloc.dart';
import 'package:xhabits/src/presentation/scenes/home/home_screen.dart';
import 'package:xhabits/src/presentation/scenes/save_habit/save_habit.dart';
import 'package:xhabits/src/presentation/widgets/xh_bottom_bar.dart';
import 'package:xhabits/src/presentation/widgets/xh_bottom_bar_bloc.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  BaseScreenBloc _baseScreenBloc;
  XHBottomBar _bottomBar;

  @override
  _BaseScreenState(){
    _baseScreenBloc = BaseScreenBloc();
    _bottomBar = XHBottomBar(_baseScreenBloc.bottomBarBloc);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(context),
        bottomNavigationBar: _bottomBar.buildBottomBar(),
      );

  void changeTab(){

  }

  Widget _body(BuildContext context) => StreamBuilder<int>(
    stream: _baseScreenBloc.selectedIndexObservable,
    builder: (context, snapshot) => Stack(
            children: <Widget>[
              _homeScreen(),
              _progress(),
              _profile(),
            ],
          )
  );

  Widget _homeScreen() => Offstage(
    offstage: 0 != _bottomBar.getCurrentIndex(),
    child: HomeScreen()
  );

  Widget _progress() => Offstage(
      offstage: 1 != _bottomBar.getCurrentIndex(),
    child: SaveHabit.create(),
  );

  Widget _profile() => Offstage(
      offstage: 2 != _bottomBar.getCurrentIndex(),
  );
}
