import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xhabits/src/data/entities/habit.dart';

class FirebaseDatabaseServiceMobile implements DatabaseService {
  final _database = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;
  final BehaviorSubject<bool> _globalNotificationsSubject = BehaviorSubject<bool>();

  void _initGlobalNotifications() async {
      String userId = (await _auth.currentUser()).uid;
      String notificationPath = _database.child(userId).child('notificationsOn').path;
      await _database
          .child(notificationPath)
          .once()
          .then((snapshot) {
         if (snapshot.value == null) {
           _database.child(notificationPath).set(true);
         }
      });

      _database.reference().child(userId).onChildChanged.listen((event) {
        print('info that changed: ${event.snapshot.key}: ${event.snapshot.value}');
        if (event.snapshot.key == 'notificationsOn') {
          _globalNotificationsSubject.add(event.snapshot.value as bool);
        }
      });
      
      _globalNotificationsSubject.sink.add((await _database
          .child(notificationPath)
          .once())
          .value as bool);
  }

  @override
  Stream<List<Habit>> getHabits() {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      List<Habit> result = ((await _database
          .child(userId)
          .child('habits')
          .once())
          .value as Map<dynamic, dynamic> ?? {})
          .entries
          .map((item) => Habit(item.key as String, item.value as Map))
          .toList();

      result.sort((h1, h2) => h1.habitId.compareTo(h2.habitId));
      return result;
    }

    return Stream.fromFuture(getFuture());
  }

  @override
  BehaviorSubject<bool> getGlobalNotificationsStatus() {
    _initGlobalNotifications();
    return _globalNotificationsSubject;
  }

  @override
  Stream<bool> createHabit(String habitId, String title, bool enableNotification,
      String startDate, {String endDate, String notificationTime}) {
    getFuture() async {
      FirebaseUser user = await _auth.currentUser();
      await _database.child(user.uid).child('habits').child(habitId).set({
        'title': title,
        'enable_notification': enableNotification,
        'start_date': startDate,
        'end_date': endDate,
        'notification_time': notificationTime,
      });
      return true;
    }

    return Stream.fromFuture(getFuture());
  }

  @override
  Stream<bool> updateGlobalNotifications(bool notificationsOn){
    getFuture() async {
      FirebaseUser user = await _auth.currentUser();
      await _database.child(user.uid).child('notificationsOn').set(
        notificationsOn);
      return true;
    }
    return Stream.fromFuture(getFuture());
  }

  @override
  Stream<bool> updateHabit(String habitId, String title, bool enableNotification,
      String startDate, List<DateTime> checkedDays, {String endDate, String notificationTime}) {
    getFuture() async {
      FirebaseUser user = await _auth.currentUser();
      await _database.child(user.uid).child('habits').child(habitId).set({
        'title': title,
        'enable_notification': enableNotification,
        'start_date': startDate,
        'end_date': endDate,
        'notification_time': notificationTime,
        'checked_days': checkedDays.map((item) => item.toString()).toList()
      });
      return true;
    }

    return Stream.fromFuture(getFuture());
  }

  @override
  void removeHabit(String habitId) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.child(user.uid).child('habits').child(habitId).remove();
  }

  @override
  void removeHabits(List<String> habitIds) async {
    habitIds.forEach(removeHabit);
  }

  @override
  void updateCheckedDays(String habitId, List<DateTime> checkedDays) async {
    FirebaseUser user = await _auth.currentUser();
    await _database
        .child(user.uid)
        .child('habits')
        .child(habitId)
        .update({'checked_days': checkedDays.map((item) => item.toString()).toList()});
  }
}