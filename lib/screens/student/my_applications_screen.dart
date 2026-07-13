import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/application_model.dart';
import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/application_card.dart';
import '../../widgets/empty_state_widget.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;
    final applicationProvider = Provider.of<ApplicationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<ApplicationModel>>(
              stream: applicationProvider.getApplicationsByStudent(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final applications = snapshot.data ?? [];

                if (applications.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No applications yet',
                    subtitle:
                        'When you apply to opportunities, they will appear here.',
                    icon: Icons.assignment_outlined,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    return ApplicationCard(
                      application: applications[index],
                    );
                  },
                );
              },
            ),
    );
  }
}