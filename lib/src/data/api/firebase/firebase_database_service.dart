import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseService implements DatabaseService {
  final _database = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;

  @override
  Observable<List<String>> getHabitIds() {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      List<String> result = ((await _database
          .child(userId)
          .child('habits')
          .once())
          .value as Map<dynamic, dynamic>)
          .keys
          .map((item) => item.toString())
          .toList();

      return result;
    }

    return Observable.fromFuture(getFuture());
  }

  @override
  Observable<List<DateTime>> getHabitCheckedDays(String habitId) {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      List<DateTime> result = (((await _database
                  .child(userId)
                  .child('habits')
                  .child(habitId)
                  .child('checked_days')
                  .once())
              .value as List<dynamic>))
          .map((item) => DateTime.parse(item.toString()))
          .toList();

      return result;
    }

    return Observable.fromFuture(getFuture());
  }

  @override
  Observable<String> getHabitTitle(String habitId) {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      String result = (await _database
              .child(userId)
              .child('habits')
              .child(habitId)
              .child('title')
              .once())
          .value as String;

      return result;
    }

    return Observable.fromFuture(getFuture());
  }

  @override
  void createHabit(String habitId, String title) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.child(user.uid).child('habits').child(habitId).set({
      'title': title,
    });
  }

  @override
  void removeHabit(String habitId) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.child(user.uid).child('habits').child(habitId).remove();
  }
}
