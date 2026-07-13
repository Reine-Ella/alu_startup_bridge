import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: const Color(0xFF0B1F4D),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 720),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFFFB800),
                  child: Icon(
                    Icons.school_outlined,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 22),

                Text(
                  user?.name ?? 'Student',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17233C),
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  user?.email ?? 'No email available',
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 28),

                _infoTile(
                  icon: Icons.badge_outlined,
                  title: 'Account Type',
                  value: 'Student',
                ),
                _infoTile(
                  icon: Icons.work_outline,
                  title: 'Can Browse Opportunities',
                  value: 'Yes',
                ),
                _infoTile(
                  icon: Icons.assignment_outlined,
                  title: 'Can Apply to Opportunities',
                  value: 'Yes',
                ),
                _infoTile(
                  icon: Icons.track_changes_outlined,
                  title: 'Can Track Applications',
                  value: 'Yes',
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EFEF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFB800)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF17233C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}