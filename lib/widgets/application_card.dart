import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/application_model.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({
    super.key,
    required this.application,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Shortlisted':
        return Colors.orange;
      case 'Under Review':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(application.status);

    return Card(
      elevation: 0,
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              application.opportunityTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              application.startupName,
              style: const TextStyle(
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                application.status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}