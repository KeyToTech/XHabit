import 'package:flutter/material.dart';
import 'package:xhabits/src/data/api/firebase/firebase_database_service_mobile.dart';
import 'config/app_config.dart';
import 'src/presentation/XHApp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.database = FirebaseDatabaseServiceMobile();
  runApp(XHApp());
}
