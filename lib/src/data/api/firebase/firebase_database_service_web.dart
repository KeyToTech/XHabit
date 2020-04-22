import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:firebase/firebase.dart';

class FirebaseDatabaseServiceWeb implements DatabaseService {
  final _database = database();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseStorage.instance;

  final BehaviorSubject<bool> _globalNotificationsSubject = BehaviorSubject<bool>();

  @override
  void uploadProfilePic(File image) async {
      String userId = (await _auth.currentUser()).uid;
      var storageReference = _firestore
          .ref()
          .child(userId)
          .child('images');
      StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
      print('File uploaded');
      var imageURL = await storageReference.getDownloadURL();
  }

  Stream<String> getProfilePic(){
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      String result = ((await _database.ref(userId)
          .child('image')
          .once('value'))
          .snapshot
          .val() as String);
      return result;
    }
    return Stream.fromFuture(getFuture());
  }

  @override
  Stream<List<Habit>> getHabits() {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      List<Habit> result = ((await _database
          .ref(userId)
          .child('habits')
          .once('value'))
          .snapshot
          .val() as Map<dynamic, dynamic> ?? {})
          .entries
          .map((item) => Habit(item.key as String, item.value as Map))
          .toList();

      result.sort((h1, h2) => h1.habitId.compareTo(h2.habitId));
      return result;
    }

    return Stream.fromFuture(getFuture());
  }

  @override
  Stream<bool> createHabit(String habitId, String title, bool enableNotification,
      String startDate, {String endDate, String notificationTime}) {
    getFuture() async {
      FirebaseUser user = await _auth.currentUser();
      await _database.ref(user.uid).child('habits').child(habitId).set({
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
  Stream<bool> updateHabit(String habitId, String title, bool enableNotification,
      String startDate, List<DateTime> checkedDays, {String endDate, String notificationTime}) {
    getFuture() async {
      FirebaseUser user = await _auth.currentUser();
      await _database.ref(user.uid).child('habits').child(habitId).set({
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
  Stream<bool> updateGlobalNotifications(bool notificationsOn){
    getFuture() async {
      FirebaseUser user = await _auth.currentUser();
      await _database.ref(user.uid).child('notificationsOn').set(
          notificationsOn);
      return true;
    }
    return Stream.fromFuture(getFuture());
  }

  @override
  BehaviorSubject<bool> getGlobalNotificationsStatus(){
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      bool result = ((await _database
          .ref(userId)
          .child('notificationsOn')
          .once('value'))
          .snapshot
          .val() as bool);
      _globalNotificationsSubject.sink.add(result);
    }
    return _globalNotificationsSubject;
  }


  @override
  void removeHabit(String habitId) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.ref(user.uid).child('habits').child(habitId).remove();
  }

  @override
  void removeHabits(List<String> habitIds) async {
    habitIds.forEach(removeHabit);
  }

  @override
  void updateCheckedDays(String habitId, List<DateTime> checkedDays) async {
    FirebaseUser user = await _auth.currentUser();
    await _database
        .ref(user.uid)
        .child('habits')
        .child(habitId)
        .update({'checked_days': checkedDays.map((item) => item.toString()).toList()});
  }
}
