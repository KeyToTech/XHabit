import 'package:firebase_database/firebase_database.dart';
import 'package:xhabits/src/data/api/database_service.dart';
import 'package:xhabits/src/data/entities/habit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseService implements DatabaseService {
  final _database = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;

  @override
  Future<Habit> getHabit(String habitId) async {
    Habit result;
    FirebaseUser user = await _auth.currentUser();
    await _database
        .child(user.uid)
        .child('habits')
        .child(habitId)
        .once()
        .then((DataSnapshot snapshot) {
      print('-SERVICE $habitId- DB data: ${snapshot.value}');
      result = Habit.fromMap(snapshot.value as Map);
    });
    print('-SERVICE $habitId- checked days BEFORE RETURN: ${result.checkedDays}');
    return result;
  }

  @override
  void createHabit(String habitId, String title) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.child(user.uid).child('habits').child(habitId).set({
      'title': title,
      'checked_days': [
        DateTime(2019, 08, 25).toString(),
        DateTime(2019, 08, 24).toString(),
        DateTime(2019, 08, 21).toString(),
      ]
    });
  }

  @override
  void removeHabit(String habitId) async {
    FirebaseUser user = await _auth.currentUser();
    await _database.child(user.uid).child('habits').child(habitId).remove();
  }
}
