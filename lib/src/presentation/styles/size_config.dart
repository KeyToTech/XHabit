import 'package:flutter/material.dart';

class SizeConfig {
  static Size screenSize;
  static final double appBarButtonText = screenSize.height * 0.023;
  static final double appBarTitle = screenSize.height * 0.027;
  static final EdgeInsetsGeometry saveScreenPadding = EdgeInsets.symmetric(
    vertical: screenSize.height * 0.02,
    horizontal: screenSize.width * 0.035,
  );
  static final double saveScreenLargeText = screenSize.height * 0.03;
  static final EdgeInsetsGeometry appBarCancelButtonPadding =
      EdgeInsets.only(right: screenSize.width * 0.09);
  static final EdgeInsetsGeometry appBarSaveButtonPadding =
      EdgeInsets.only(left: screenSize.width * 0.1);
  static final double saveScreenTitleText = screenSize.height * 0.04;
  static final EdgeInsetsGeometry saveScreenInputMargin =
      EdgeInsets.only(top: screenSize.height * 0.045);
  static final double saveScreenSmallText = screenSize.height * 0.02;
  static final double pickersDividerThickness =
      screenSize.shortestSide * 0.0015;
  static final double pickersDividerHeight = screenSize.height * 0.06;
  static final EdgeInsetsGeometry pickerPadding =
      EdgeInsets.only(left: screenSize.width * 0.04);
  static final EdgeInsetsGeometry pickedTextPadding =
      EdgeInsets.only(right: screenSize.width * 0.04);
  static final double pickerText = screenSize.height * 0.025;
}
