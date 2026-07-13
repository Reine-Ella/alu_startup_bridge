import 'package:flutter/material.dart';

import '../models/startup_model.dart';
import '../services/startup_service.dart';

class StartupProvider extends ChangeNotifier {
  final StartupService _startupService = StartupService();

  bool isLoading = false;
  String? errorMessage;
  StartupModel? currentStartup;

  Future<bool> createStartup({
    required String id,
    required String founderId,
    required String startupName,
    required String founderName,
    required String description,
    required String category,
    required String email,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final startup = StartupModel(
        id: id,
        founderId: founderId,
        startupName: startupName.trim(),
        founderName: founderName.trim(),
        description: description.trim(),
        category: category.trim(),
        email: email.trim(),
        verified: false,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _startupService.createStartupProfile(startup);

      currentStartup = startup;

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

  Future<void> loadStartupByFounder(String founderId) async {
    currentStartup = await _startupService.getStartupByFounderId(founderId);
    notifyListeners();
  }

  Stream<List<StartupModel>> getAllStartups() {
    return _startupService.getAllStartups();
  }
}