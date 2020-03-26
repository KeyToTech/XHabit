import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/widgets/xh_icon_button_bloc.dart';

class XHIconButton {
  String _text;
  IconData _icon;
  Color _color;
  bool _withSwitcher;
  void Function() action;
  XHIconButtonBloc xhIconButtonBloc;

  XHIconButton(String text, IconData icon, Color color, bool withSwitcher,
      bool switcherValue, Function() action) {
    this._text = text;
    this._icon = icon;
    this._color = color;
    this._withSwitcher = withSwitcher;
    this.action = action;
    this.xhIconButtonBloc = XHIconButtonBloc(switcherValue);
  }

  Widget _mainRow(bool switcherValue) {
    List<Widget> children = new List();
    children.add(Padding(
      padding: const EdgeInsets.only(left: 20, right: 30),
      child: Icon(
        _icon,
        color: _color,
      ),
    ));
    children.add(Text(_text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          color: XHColors.lightGrey,
        )));
    if (_withSwitcher) {
      children.add(CupertinoSwitch(
          activeColor: XHColors.pink,
          value: switcherValue,
          onChanged: (value) {
            action();
            xhIconButtonBloc.switcherChanged();
          }));
    }
    return Row(children: children);
  }

  Widget IconButton() => StreamBuilder<bool>(
      stream: xhIconButtonBloc.notificationsOnObservable,
      builder: (context, snapshot) => GestureDetector(
          onTap: action,
          child: _mainRow(snapshot.data ?? false),
        ));
}
