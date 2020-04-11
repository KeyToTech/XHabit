import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';
import 'package:xhabits/src/presentation/widgets/xh_bottom_bar_bloc.dart';

class XHBottomBar {

  XHBottomBarBloc _xhBottomBarBloc;

  int getCurrentIndex() => _xhBottomBarBloc.currentIndex;

  XHBottomBar(XHBottomBarBloc bloc){
    _xhBottomBarBloc = bloc;
  }

  Widget buildBottomBar() => StreamBuilder<int>(
    stream: _xhBottomBarBloc.currentIndexObservable,
    builder: (context, snapshot) => BottomNavigationBar(
        backgroundColor: XHColors.darkGrey,
        iconSize: SizeConfig.bottomBarIconSize,
        onTap: _xhBottomBarBloc.currentIndexChanged,
        currentIndex: _xhBottomBarBloc.currentIndex,
        unselectedItemColor: XHColors.lightGrey,
        unselectedFontSize: SizeConfig.bottomBarTitlesSize,
        selectedFontSize: SizeConfig.bottomBarTitlesSize,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat),
            title: Text('Habits'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            title: Text('Progress'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Profile'),
          )
        ],
      )
  );


}