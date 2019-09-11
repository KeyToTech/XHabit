import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseService implements DatabaseService {
  final _database = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;

  @override
  Observable<List<DateTime>> getHabitCheckedDays(String habitId) {
    getFuture() async {
      print('SERVICE -$habitId- CHECKED DAYS START getFuture()');
      String userId = (await _auth.currentUser()).uid;
      print('USERID: $userId');
      List<DateTime> result = (((await _database
                  .child(userId)
                  .child('habits')
                  .child(habitId)
                  .child('checked_days')
                  .once())
              .value as List<dynamic>))
          .map((item) => DateTime.parse(item.toString()))
          .toList();
      print('getFuture() CH DAYS RESULT: $result');
      return result;
    }

    print('SERVICE -$habitId- CHECKED DAYS BEFORE RETURN');
    return Observable.fromFuture(getFuture());
  }

  @override
  Observable<String> getHabitTitle(String habitId) {
    getFuture() async {
      print('SERVICE -$habitId- TITLE START getFuture()');
      String userId = (await _auth.currentUser()).uid;
      print('USERID: $userId');
      String result = (await _database
              .child(userId)
              .child('habits')
              .child(habitId)
              .child('title')
              .once())
          .value as String;
      print('getFuture() TITLE RESULT: $result');
      return result;
    }

    print('SERVICE -$habitId- TITLE BEFORE RETURN');
    return Observable.fromFuture(getFuture());
  }

  /*getHabit(String habitId) async {
    String userId;
    userId = (await _auth.currentUser()).uid;
    var result =
    (await _database.child(userId).child('habits').child(habitId).once()).;
    return result;
  }*/

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
