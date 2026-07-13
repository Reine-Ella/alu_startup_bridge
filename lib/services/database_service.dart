import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../constants/database_paths.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://startupbridge-4c5de-default-rtdb.firebaseio.com/',
  );

  late final DatabaseReference _databaseRef = _database.ref();

  Future<void> createUserProfile(UserModel user) async {
    await _databaseRef
        .child(DatabasePaths.users)
        .child(user.uid)
        .set(user.toMap());
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final snapshot = await _databaseRef
        .child(DatabasePaths.users)
        .child(uid)
        .get();

    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }

    final data = snapshot.value as Map<dynamic, dynamic>;
    return UserModel.fromMap(data);
  }
}