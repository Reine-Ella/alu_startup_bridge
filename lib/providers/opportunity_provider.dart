import 'package:flutter/material.dart';

import '../models/opportunity_model.dart';
import '../services/opportunity_service.dart';

class OpportunityProvider extends ChangeNotifier {
  final OpportunityService _opportunityService = OpportunityService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> createOpportunity({
    required String id,
    required String startupId,
    required String startupName,
    required String title,
    required String description,
    required String category,
    required String location,
    required String type,
    required String requiredSkills,
    required String duration,
    required String weeklyHours,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final opportunity = OpportunityModel(
        id: id,
        startupId: startupId,
        startupName: startupName,
        title: title.trim(),
        description: description.trim(),
        category: category.trim(),
        location: location.trim(),
        type: type.trim(),
        requiredSkills: requiredSkills.trim(),
        duration: duration.trim(),
        weeklyHours: weeklyHours.trim(),
        status: 'open',
        createdAt: DateTime.now().toIso8601String(),
      );

      await _opportunityService.createOpportunity(opportunity);

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteOpportunity(String opportunityId) async {
    await _opportunityService.deleteOpportunity(opportunityId);
  }

  Stream<List<OpportunityModel>> getAllOpportunities() {
    return _opportunityService.getAllOpportunities();
  }

  Stream<List<OpportunityModel>> getOpportunitiesByStartup(String startupId) {
    return _opportunityService.getOpportunitiesByStartup(startupId);
  }
}