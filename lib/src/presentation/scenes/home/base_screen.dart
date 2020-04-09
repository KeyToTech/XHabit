import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/widgets/xh_bottom_bar.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  _BaseScreenState();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(context),
        bottomNavigationBar: XHBottomBar(0).buildBottomBar(),
      );

  Widget _body(BuildContext context) => Container(color: XHColors.darkGrey);
}
