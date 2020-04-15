import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';
import 'package:xhabits/src/presentation/widgets/xh_icon_button_bloc.dart';

class XHIconButton {
  String _text;
  IconData _icon;
  Color _color;
  bool _withSwitcher;
  void Function() action;
  void Function() onSwitcherAction;
  XHIconButtonBloc xhIconButtonBloc;

  XHIconButton(String text, IconData icon, Color color, bool withSwitcher, Function() action,
  {bool switcherValue, Function() onSwitcherAction}) {
    this._text = text;
    this._icon = icon;
    this._color = color;
    this._withSwitcher = withSwitcher;
    this.action = action;
    this.onSwitcherAction = onSwitcherAction;
    this.xhIconButtonBloc = XHIconButtonBloc(switcherValue);
  }

  Widget _mainRow(bool switcherValue) {
    List<Widget> children = List();
    children.add(Row(
      children: <Widget>[
        Padding(
          padding: SizeConfig.profileScreenIconOnButtonPadding,
          child: Icon(
            _icon,
            color: _color,
          ),
        ),
        Text(_text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: SizeConfig.profileScreenButtonText,
              color: XHColors.lightGrey,
            )),
      ],
    ));
    if (_withSwitcher) {
      children.add(Padding(
        padding: SizeConfig.profileScreenSwitcherPadding,
        child: CupertinoSwitch(
            activeColor: XHColors.pink,
            value: switcherValue,
            onChanged: (value) {
              onSwitcherAction();
              xhIconButtonBloc.switcherChanged();
            }),
      ));
    }
    return Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children);
  }

  Widget IconButton() => StreamBuilder<bool>(
      stream: xhIconButtonBloc.notificationsOnObservable,
      builder: (context, snapshot) => GestureDetector(
          onTap: action,
          child: _mainRow(snapshot.data ?? false),
        ));
}
