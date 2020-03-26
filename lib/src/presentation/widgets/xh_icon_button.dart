import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';

class XHIconButton {

  final String text;
  final IconData icon;
  final Color color;
  final void Function() action;

  XHIconButton(this.text, this.icon, this.color, this.action);

  Widget IconButton() => GestureDetector(
    onTap: action,
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 30),
          child: Icon(icon, color: color,),
        ),
        Text(text, style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          color: XHColors.lightGrey,
        ),)

      ],
    ),
  );


}