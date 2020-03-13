import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service_mobile.dart';
import 'config/app_config.dart';
import 'src/presentation/XHApp.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  Crashlytics.instance.enableInDevMode = false;
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.database = FirebaseDatabaseServiceMobile();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() {
    runApp(XHApp());
  }, onError: Crashlytics.instance.recordError);
}

