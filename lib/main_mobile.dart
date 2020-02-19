import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service_mobile.dart';
import 'config/app_config.dart';
import 'src/presentation/XHApp.dart';

void main() {
  Crashlytics.instance.log('YOUR LOG COMES HERE');
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.database = FirebaseDatabaseServiceMobile();
  runApp(XHApp());
}
