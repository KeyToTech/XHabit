import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service_web.dart';
import 'config/app_config.dart';
import 'config/firebase_config.dart';
import 'src/presentation/XHApp.dart';

void main() {
  firebaseWebConfig();
  AppConfig.database = FirebaseDatabaseServiceWeb();
  runApp(XHApp());
}
