import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final titleController = TextEditingController();
  final startupNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final skillsController = TextEditingController();
  final durationController = TextEditingController();
  final weeklyHoursController = TextEditingController();

  String category = 'Engineering';
  String location = 'On-campus';
  String type = 'Part-time';

  Future<void> postOpportunity() async {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    final opportunityProvider =
        Provider.of<OpportunityProvider>(context, listen: false);

    final user = authProvider.currentUserProfile;
    if (user == null) return;

    if (titleController.text.trim().isEmpty ||
        startupNameController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        skillsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final opportunityId =
        'opp_${user.uid}_${DateTime.now().millisecondsSinceEpoch}';

    final success = await opportunityProvider.createOpportunity(
      id: opportunityId,
      startupId: user.uid,
      startupName: startupNameController.text,
      title: titleController.text,
      description: descriptionController.text,
      category: category,
      location: location,
      type: type,
      requiredSkills: skillsController.text,
      duration: durationController.text.isEmpty
          ? 'Not specified'
          : durationController.text,
      weeklyHours: weeklyHoursController.text.isEmpty
          ? 'Not specified'
          : weeklyHoursController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opportunity posted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(opportunityProvider.errorMessage ?? 'Failed to post opportunity'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final opportunityProvider = Provider.of<OpportunityProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text('Post Opportunity'),
        backgroundColor: const Color(0xFF0B1F4D),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CustomTextField(
            label: 'Opportunity Title',
            controller: titleController,
            icon: Icons.work_outline,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Startup Name',
            controller: startupNameController,
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: 16),
          _dropdown(
            value: category,
            items: const [
              'Engineering',
              'Design',
              'Marketing',
              'Data',
              'Business',
              'Operations',
              'Research',
              'Content Creation',
            ],
            onChanged: (value) {
              setState(() {
                category = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          _dropdown(
            value: location,
            items: const [
              'On-campus',
              'Remote',
              'Hybrid',
              'Kigali',
            ],
            onChanged: (value) {
              setState(() {
                location = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          _dropdown(
            value: type,
            items: const [
              'Part-time',
              'Internship',
              'Volunteer',
              'Project-based',
            ],
            onChanged: (value) {
              setState(() {
                type = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Required Skills',
            controller: skillsController,
            icon: Icons.psychology_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Duration e.g. 2 months',
            controller: durationController,
            icon: Icons.calendar_month_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Weekly Hours e.g. 6-8 hrs/week',
            controller: weeklyHoursController,
            icon: Icons.access_time,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Describe the opportunity...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Post Opportunity',
            isLoading: opportunityProvider.isLoading,
            onPressed: postOpportunity,
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}