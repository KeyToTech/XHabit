import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/scenes/base/base_screen_bloc.dart';
import 'package:xhabits/src/presentation/scenes/home/tab_navigator/home_tab_navigator.dart';
import 'package:xhabits/src/presentation/scenes/profile/tab_navigator/profile_tab_navigator.dart';
import 'package:xhabits/src/presentation/widgets/xh_bottom_bar.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  BaseScreenBloc _baseScreenBloc;
  XHBottomBar _bottomBar;

  @override
  _BaseScreenState() {
    _baseScreenBloc = BaseScreenBloc();
    _bottomBar = XHBottomBar(_baseScreenBloc.bottomBarBloc);

  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(context),
        bottomNavigationBar: _bottomBar.buildBottomBar(),
        resizeToAvoidBottomInset: false,
      );

  void changeTab() {}

  Widget _body(BuildContext context) => StreamBuilder<int>(
      stream: _baseScreenBloc.selectedIndexObservable,
      builder: (context, snapshot) => WillPopScope(
            onWillPop: () async =>
                !await _navigatorKeys[_bottomBar.getCurrentIndex()]
                    .currentState
                    .maybePop(),
            child: Stack(
                children: <Widget>[
                  _homeScreen(),
                  _progress(),
                  _profile(),
                ],
            ),
          ));

  Widget _homeScreen() => Offstage(
      offstage: 0 != _bottomBar.getCurrentIndex(),
      child: HomeTabNavigator(_navigatorKeys[0]));

  Widget _progress() => Offstage(
        offstage: 1 != _bottomBar.getCurrentIndex(),
        //child: ProgressTabNavigator(_navigatorKeys[1])
      );

  Widget _profile() => Offstage(
        offstage: 2 != _bottomBar.getCurrentIndex(),
        child: ProfileTabNavigator(_navigatorKeys[2])
      );
}
