import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUserProfile;

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.register(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final user = UserModel(
        uid: uid,
        name: name.trim(),
        email: email.trim(),
        role: role,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _databaseService.createUserProfile(user);

      // After account creation, sign out so the user logs in manually.
      await _authService.logout();
      currentUserProfile = null;

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

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.login(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      currentUserProfile = await _databaseService.getUserProfile(uid);

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

  Future<void> logoutUser() async {
    await _authService.logout();
    currentUserProfile = null;
    notifyListeners();
  }
}