import 'package:flutter/material.dart';

class SizeConfig {
  final Size _screenSize;
  final double appBarButtonText;
  final double appBarTitle;
  final EdgeInsetsGeometry saveScreenPadding;
  final double saveScreenLargeText;
  final EdgeInsetsGeometry saveScreenInputMargin;
  final double saveScreenSmallText;
  final double pickersDividerThickness;
  final double pickersDividerHeight;
  final EdgeInsetsGeometry pickedTextPadding;
  final double pickerText;

  SizeConfig(this._screenSize)
      : appBarButtonText = _screenSize.height * 0.023,
        appBarTitle = _screenSize.height * 0.027,
        saveScreenPadding = EdgeInsets.symmetric(
          vertical: _screenSize.height * 0.02,
          horizontal: _screenSize.width * 0.035,
        ),
        saveScreenLargeText = _screenSize.height * 0.03,
        saveScreenInputMargin = EdgeInsets.only(
          top: _screenSize.height * 0.045,
        ),
        saveScreenSmallText = _screenSize.height * 0.02,
        pickersDividerThickness = _screenSize.shortestSide * 0.0015,
        pickersDividerHeight = _screenSize.height * 0.06,
        pickedTextPadding = EdgeInsets.only(right: _screenSize.width * 0.04),
        pickerText = _screenSize.height * 0.025;
}
