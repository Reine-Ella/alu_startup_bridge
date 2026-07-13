import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class StartupProfileScreen extends StatelessWidget {
  const StartupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text('Startup Profile'),
        backgroundColor: const Color(0xFF0B1F4D),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(28),
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
                  radius: 48,
                  backgroundColor: Color(0xFFFFB800),
                  child: Icon(
                    Icons.business_center_outlined,
                    size: 46,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user?.name ?? 'Startup',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17233C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? 'No email available',
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 26),
                _infoTile(
                  icon: Icons.verified_outlined,
                  title: 'Verification Status',
                  value: 'Verfied by ALU',
                ),
                _infoTile(
                  icon: Icons.group_outlined,
                  title: 'Startup Role',
                  value: 'Opportunity poster / Startup account',
                ),
                _infoTile(
                  icon: Icons.work_outline,
                  title: 'Can Post Opportunities',
                  value: 'Yes',
                ),
                _infoTile(
                  icon: Icons.people_outline,
                  title: 'Can Manage Applicants',
                  value: 'Yes',
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
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