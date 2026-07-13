import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/application_model.dart';
import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/empty_state_widget.dart';

class ApplicantsScreen extends StatelessWidget {
  const ApplicantsScreen({super.key});

  Future<void> updateStatus(
    BuildContext context,
    String applicationId,
    String status,
  ) async {
    final provider = Provider.of<ApplicationProvider>(context, listen: false);

    await provider.updateApplicationStatus(
      applicationId: applicationId,
      status: status,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application marked as $status'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;
    final applicationProvider = Provider.of<ApplicationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text('Applicants'),
        backgroundColor: const Color(0xFF0B1F4D),
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<ApplicationModel>>(
              stream: applicationProvider.getApplicationsByStartup(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final applications = snapshot.data ?? [];

                if (applications.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No applicants yet',
                    subtitle:
                        'When students apply to your opportunities, they will appear here.',
                    icon: Icons.people_outline,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final application = applications[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            application.studentName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF17233C),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            application.studentEmail,
                            style: const TextStyle(
                              color: Color(0xFF777777),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Applied for: ${application.opportunityTitle}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF17233C),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            application.motivation,
                            style: const TextStyle(
                              color: Color(0xFF777777),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Current Status: ${application.status}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFB800),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _statusButton(
                                context,
                                application.id,
                                'Under Review',
                              ),
                              _statusButton(
                                context,
                                application.id,
                                'Shortlisted',
                              ),
                              _statusButton(
                                context,
                                application.id,
                                'Accepted',
                              ),
                              _statusButton(
                                context,
                                application.id,
                                'Rejected',
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _statusButton(
    BuildContext context,
    String applicationId,
    String status,
  ) {
    return OutlinedButton(
      onPressed: () => updateStatus(context, applicationId, status),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0B1F4D),
        side: const BorderSide(color: Color(0xFF0B1F4D)),
      ),
      child: Text(status),
    );
  }
}