import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xhabits/src/data/entities/habit.dart';

class FirebaseDatabaseService implements DatabaseService {
  final _database = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;

  @override
  Observable<List<Habit>> getHabits() {
    getFuture() async {
      String userId = (await _auth.currentUser()).uid;
      List<Habit> result =
          ((await _database.child(userId).child('habits').once()).value
                  as Map<dynamic, dynamic>)
              .values
              .map((item) => Habit(item as Map))
              .toList();

      return result;
    }

    return Observable.fromFuture(getFuture());
  }

  @override
  Observable<bool> createHabit(String habitId, String title, String description,
      String startDate, String endDate) {
    getFuture() async {
      FirebaseUser user = await _auth.currentUser();
      await _database.child(user.uid).child('habits').child(habitId).set({
        'title': title,
        'description': description,
        'start_date': startDate,
        'end_date': endDate,
      });
      return true;
    }

    return Observable.fromFuture(getFuture());
  }

  @override
  void removeHabit(String habitId) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.child(user.uid).child('habits').child(habitId).remove();
  }
}
