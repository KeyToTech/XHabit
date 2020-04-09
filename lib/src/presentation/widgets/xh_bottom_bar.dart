import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/widgets/xh_bottom_bar_bloc.dart';

class XHBottomBar {

  XHBottomBarBloc _xhBottomBarBloc;


  XHBottomBar(int index){
    _xhBottomBarBloc = XHBottomBarBloc(index);
  }

  Widget buildBottomBar() => StreamBuilder<Object>(
    stream: _xhBottomBarBloc.currentIndexObservable,
    builder: (context, snapshot) => BottomNavigationBar(
        backgroundColor: XHColors.darkGrey,
        iconSize: 35,
        onTap: _xhBottomBarBloc.currentIndexChanged,
        currentIndex: _xhBottomBarBloc.currentIndex,
        unselectedItemColor: XHColors.lightGrey,
        unselectedFontSize: 12,
        selectedFontSize: 12,
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