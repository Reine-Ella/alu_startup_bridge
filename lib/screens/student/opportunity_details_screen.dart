import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/opportunity_model.dart';
import 'apply_screen.dart';

class OpportunityDetailsScreen extends StatelessWidget {
  final OpportunityModel opportunity;

  const OpportunityDetailsScreen({
    super.key,
    required this.opportunity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: ListView(
          children: [
            Text(
              opportunity.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.startupName,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 24),
            _infoRow(Icons.category_outlined, 'Category', opportunity.category),
            _infoRow(Icons.location_on_outlined, 'Location', opportunity.location),
            _infoRow(Icons.schedule_outlined, 'Type', opportunity.type),
            _infoRow(Icons.timer_outlined, 'Duration', opportunity.duration),
            _infoRow(Icons.access_time, 'Weekly Hours', opportunity.weeklyHours),
            const SizedBox(height: 24),
            const Text(
              'Skills Required',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.requiredSkills,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'About this opportunity',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.description,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApplyScreen(opportunity: opportunity),
                    ),
                  );
                },
                child: const Text(
                  'Apply Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textLight),
            ),
          ),
        ],
      ),
    );
  }
}