import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../constants/database_paths.dart';
import '../models/opportunity_model.dart';

class OpportunityService {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://startupbridge-4c5de-default-rtdb.firebaseio.com/',
  );

  late final DatabaseReference _databaseRef = _database.ref();

  Future<void> createOpportunity(OpportunityModel opportunity) async {
    await _databaseRef
        .child(DatabasePaths.opportunities)
        .child(opportunity.id)
        .set(opportunity.toMap());
  }

  Future<void> updateOpportunity(OpportunityModel opportunity) async {
    await _databaseRef
        .child(DatabasePaths.opportunities)
        .child(opportunity.id)
        .update(opportunity.toMap());
  }

  Future<void> deleteOpportunity(String opportunityId) async {
    await _databaseRef
        .child(DatabasePaths.opportunities)
        .child(opportunityId)
        .remove();
  }

  Stream<List<OpportunityModel>> getAllOpportunities() {
    return _databaseRef.child(DatabasePaths.opportunities).onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return [];
      }

      final opportunitiesMap = data as Map<dynamic, dynamic>;

      final opportunities = opportunitiesMap.entries.map((entry) {
        final opportunityData = entry.value as Map<dynamic, dynamic>;
        return OpportunityModel.fromMap(opportunityData);
      }).toList();

      opportunities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return opportunities;
    });
  }

  Stream<List<OpportunityModel>> getOpportunitiesByStartup(String startupId) {
    return _databaseRef.child(DatabasePaths.opportunities).onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return [];
      }

      final opportunitiesMap = data as Map<dynamic, dynamic>;

      final opportunities = opportunitiesMap.entries
          .map((entry) {
            final opportunityData = entry.value as Map<dynamic, dynamic>;
            return OpportunityModel.fromMap(opportunityData);
          })
          .where((opportunity) => opportunity.startupId == startupId)
          .toList();

      opportunities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return opportunities;
    });
  }
}