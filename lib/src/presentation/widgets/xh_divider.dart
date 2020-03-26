import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';

class XHDivider {

  XHDivider();

  Divider drowPickersDivider() => Divider(
    color: Colors.black,
    thickness: SizeConfig.pickersDividerThickness,
    height: SizeConfig.pickersDividerHeight,
  );


}