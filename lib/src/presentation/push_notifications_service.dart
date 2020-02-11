import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xhabits/src/presentation/scenes/info_dialog.dart';

class PushNotificationsService {
  BuildContext _context;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  NotificationDetails _platformChannelSpecifics;

  PushNotificationsService(BuildContext context) {
    _context = context;
    _init();
    _setChannelSpecifics();
  }

  void _init() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  void _setChannelSpecifics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'xh_channel_id',
      'xh_channel_name',
      'xh_channel_description',
      style: AndroidNotificationStyle.BigText,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    _platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  Future _onSelectNotification(String payload) async {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => InfoDialog().show(_context, 'Check your habit!', payload));
  }

  Future showDailyNotification(
      int pushId, String title, TimeOfDay habitTime) async {
    var time = Time(habitTime.hour, habitTime.minute, 0);
    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      pushId,
      'Check your habit!',
      title,
      time,
      _platformChannelSpecifics,
      payload: title,
    );
  }
  void cancelNotification(int index) async {
    await _flutterLocalNotificationsPlugin.cancel(index);
  }
}
