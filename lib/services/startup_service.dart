import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../constants/database_paths.dart';
import '../models/startup_model.dart';

class StartupService {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://startupbridge-4c5de-default-rtdb.firebaseio.com/',
  );

  late final DatabaseReference _databaseRef = _database.ref();

  Future<void> createStartupProfile(StartupModel startup) async {
    await _databaseRef
        .child(DatabasePaths.startups)
        .child(startup.id)
        .set(startup.toMap());
  }

  Future<StartupModel?> getStartupByFounderId(String founderId) async {
    final snapshot = await _databaseRef.child(DatabasePaths.startups).get();

    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }

    final data = snapshot.value as Map<dynamic, dynamic>;

    for (final item in data.entries) {
      final startupData = item.value as Map<dynamic, dynamic>;

      if (startupData['founderId'] == founderId) {
        return StartupModel.fromMap(startupData);
      }
    }

    return null;
  }

  Stream<List<StartupModel>> getAllStartups() {
    return _databaseRef.child(DatabasePaths.startups).onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return [];
      }

      final startupsMap = data as Map<dynamic, dynamic>;

      return startupsMap.entries.map((entry) {
        final startupData = entry.value as Map<dynamic, dynamic>;
        return StartupModel.fromMap(startupData);
      }).toList();
    });
  }
}