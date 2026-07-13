import 'package:flutter/material.dart';

import '../models/application_model.dart';
import '../services/application_service.dart';

class ApplicationProvider extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> submitApplication({
    required String id,
    required String studentId,
    required String studentName,
    required String studentEmail,
    required String opportunityId,
    required String opportunityTitle,
    required String startupId,
    required String startupName,
    required String motivation,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final application = ApplicationModel(
        id: id,
        studentId: studentId,
        studentName: studentName,
        studentEmail: studentEmail,
        opportunityId: opportunityId,
        opportunityTitle: opportunityTitle,
        startupId: startupId,
        startupName: startupName,
        motivation: motivation.trim(),
        status: 'Applied',
        createdAt: DateTime.now().toIso8601String(),
      );

      await _applicationService.submitApplication(application);

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

  Future<void> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    await _applicationService.updateApplicationStatus(
      applicationId: applicationId,
      status: status,
    );
  }

  Stream<List<ApplicationModel>> getApplicationsByStudent(String studentId) {
    return _applicationService.getApplicationsByStudent(studentId);
  }

  Stream<List<ApplicationModel>> getApplicationsByStartup(String startupId) {
    return _applicationService.getApplicationsByStartup(startupId);
  }
}