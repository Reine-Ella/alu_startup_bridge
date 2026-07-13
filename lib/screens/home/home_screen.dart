import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../student/student_home_screen.dart';
import '../startup/startup_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final provider = Provider.of<AppAuthProvider>(context, listen: false);
    await provider.logoutUser();

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user.role == 'startup') {
      return const StartupDashboardScreen();
    }

    return const StudentHomeScreen();
  }
}