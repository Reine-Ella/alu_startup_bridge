import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/opportunity_model.dart';
import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class ApplyScreen extends StatefulWidget {
  final OpportunityModel opportunity;

  const ApplyScreen({
    super.key,
    required this.opportunity,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final motivationController = TextEditingController();

  Future<void> submitApplication() async {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    final applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);

    final user = authProvider.currentUserProfile;

    if (user == null) return;

    if (motivationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a motivation message'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final applicationId =
        '${user.uid}_${widget.opportunity.id}_${DateTime.now().millisecondsSinceEpoch}';

    final success = await applicationProvider.submitApplication(
      id: applicationId,
      studentId: user.uid,
      studentName: user.name,
      studentEmail: user.email,
      opportunityId: widget.opportunity.id,
      opportunityTitle: widget.opportunity.title,
      startupId: widget.opportunity.startupId,
      startupName: widget.opportunity.startupName,
      motivation: motivationController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(applicationProvider.errorMessage ?? 'Failed to apply'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationProvider = Provider.of<ApplicationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.opportunity.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.opportunity.startupName,
              style: const TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 28),
            const Text(
              'Motivation Message',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: motivationController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Explain why you are interested in this opportunity...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Submit Application',
              isLoading: applicationProvider.isLoading,
              onPressed: submitApplication,
            ),
          ],
        ),
      ),
    );
  }
}