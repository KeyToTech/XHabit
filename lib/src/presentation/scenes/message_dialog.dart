import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/presentation/styles/XHColors.dart';
import 'package:xhabits/src/presentation/styles/size_config.dart';

class MessageDialog {
  final String titleText;
  final String messageText;
  final double titleTextfontSize;
  final double messageTextfontSize;

  MessageDialog(this.titleText, this.messageText, this.titleTextfontSize,
      this.messageTextfontSize);

  Widget messageDialog() => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          color: XHColors.darkGrey,
          child: Column(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage("assets/images/icon.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "New habit created!",
                  style: TextStyle(
                      fontSize: SizeConfig.messageDialogLargeText,
                      color: XHColors.lightGrey),
                ),
              ),
              Container(
                child: Text(
                  "Your new habit has been created!",
                  style: TextStyle(
                    fontSize: SizeConfig.messageDialogSmallText,
                    color: XHColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Ok', style: TextStyle(color: XHColors.pink)),
                    onPressed: () {
//   Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
//
//  void show(BuildContext context) async {
//    await showDialog(
//      context: context,
//      builder: (BuildContext context) => AlertDialog(
//        backgroundColor: XHColors.darkGrey,
//        shape:
//            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//        title: Column(
//          children: <Widget>[
//            Container(
//              child: Image(
//                image: AssetImage("assets/images/icon.png"),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(12.0),
//              child: Text(
//                "New habit created!",
//                style: TextStyle(
//                    fontSize: SizeConfig.messageDialogLargeText,
//                    color: XHColors.lightGrey),
//              ),
//            ),
//            Container(
//              child: Text(
//                "Your new habit has been created!",
//                style: TextStyle(
//                  fontSize: SizeConfig.messageDialogSmallText,
//                  color: XHColors.grey,
//                ),
//                textAlign: TextAlign.center,
//              ),
//            ),
//          ],
//        ),
//        actions: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              FlatButton(
//                child: Text('Ok', style: TextStyle(color: XHColors.pink)),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
}
