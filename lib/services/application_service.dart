import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../constants/database_paths.dart';
import '../models/application_model.dart';

class ApplicationService {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://startupbridge-4c5de-default-rtdb.firebaseio.com/',
  );

  late final DatabaseReference _databaseRef = _database.ref();

  Future<void> submitApplication(ApplicationModel application) async {
    await _databaseRef
        .child(DatabasePaths.applications)
        .child(application.id)
        .set(application.toMap());
  }

  Future<void> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    await _databaseRef
        .child(DatabasePaths.applications)
        .child(applicationId)
        .update({
      'status': status,
    });
  }

  Future<void> deleteApplication(String applicationId) async {
    await _databaseRef
        .child(DatabasePaths.applications)
        .child(applicationId)
        .remove();
  }

  Stream<List<ApplicationModel>> getApplicationsByStudent(String studentId) {
    return _databaseRef.child(DatabasePaths.applications).onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return [];
      }

      final applicationsMap = data as Map<dynamic, dynamic>;

      final applications = applicationsMap.entries
          .map((entry) {
            final applicationData = entry.value as Map<dynamic, dynamic>;
            return ApplicationModel.fromMap(applicationData);
          })
          .where((application) => application.studentId == studentId)
          .toList();

      applications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return applications;
    });
  }

  Stream<List<ApplicationModel>> getApplicationsByStartup(String startupId) {
    return _databaseRef.child(DatabasePaths.applications).onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return [];
      }

      final applicationsMap = data as Map<dynamic, dynamic>;

      final applications = applicationsMap.entries
          .map((entry) {
            final applicationData = entry.value as Map<dynamic, dynamic>;
            return ApplicationModel.fromMap(applicationData);
          })
          .where((application) => application.startupId == startupId)
          .toList();

      applications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return applications;
    });
  }
}