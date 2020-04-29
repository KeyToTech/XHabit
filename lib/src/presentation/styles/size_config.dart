import 'package:flutter/material.dart';

class SizeConfig {
  static Size screenSize;
  static final double appBarButtonText = screenSize.height * 0.023;
  static final double appBarTitle = screenSize.height * 0.027;
  static final double bottomBarIconSize = screenSize.height * 0.045;
  static final double bottomBarTitlesSize = screenSize.height * 0.015;
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
  static final EdgeInsetsGeometry messageDialogTextPadding = EdgeInsets.only(
      top: screenSize.height * 0.02, bottom: screenSize.height * 0.039);
  static final EdgeInsetsGeometry messageDialogIconPadding = EdgeInsets.only(
      top: screenSize.height * 0.05, bottom: screenSize.height * 0.0185);
  static final double messageDialogLargeText = screenSize.height * 0.025;
  static final double messageDialogSmallText = screenSize.height * 0.015;
  static final double messageDialogButtonText = screenSize.height * 0.022;
  static final double messageDialogHeight = screenSize.height * 0.29;
  static final double messageDialogWidth = screenSize.height * 0.55;
  static final double pickersDividerThickness =
      screenSize.shortestSide * 0.0015;
  static final double pickersDividerHeight = screenSize.height * 0.06;
  static final EdgeInsetsGeometry pickerPadding =
      EdgeInsets.only(left: screenSize.width * 0.04);
  static final EdgeInsetsGeometry pickedTextPadding =
      EdgeInsets.only(right: screenSize.width * 0.04);
  static final double pickerText = screenSize.height * 0.025;
  static final EdgeInsets authScreenPadding = EdgeInsets.symmetric(
      horizontal: screenSize.width > 1000
          ? screenSize.width * 0.3
          : screenSize.width * 0.15);

  static double handleKeyboardHeight(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom + 16.0;
  static final EdgeInsetsGeometry profileScreenTitlePadding = EdgeInsets.only(
      top: screenSize.height * 0.08,
      bottom: screenSize.height * 0.1,
      left: screenSize.height * 0.03);
  static final double profileScreenTitle = screenSize.height * 0.05;
  static final double profileScreenAvatarBorderRadius =
      screenSize.height * 0.009;
  static final double profileScreenAvatarSize = screenSize.height * 0.18;
  static final double profileScreenUserName = screenSize.height * 0.025;
  static final double profileScreenUserEmail = screenSize.height * 0.015;
  static final double profileScreenUserNameTextFieldWidth = screenSize.width * 0.3;
  static final EdgeInsetsGeometry profileScreenUserTextPadding =
      EdgeInsets.only(
          top: screenSize.height * 0.02, bottom: screenSize.height * 0.007);
  static final EdgeInsetsGeometry profileImageUploadStatusIndicatorPadding =
      EdgeInsets.only(right: screenSize.width * 0.06);
  static final EdgeInsetsGeometry profileScreenFirstButtonPadding =
      EdgeInsets.only(top: screenSize.height * 0.07);
  static final EdgeInsetsGeometry profileScreenIconOnButtonPadding =
      EdgeInsets.only(
          left: screenSize.width * 0.05, right: screenSize.width * 0.05);
  static final double profileScreenButtonText = screenSize.height * 0.02;
  static final EdgeInsetsGeometry profileScreenSwitcherPadding =
      EdgeInsets.only(right: screenSize.width * 0.03);
}
