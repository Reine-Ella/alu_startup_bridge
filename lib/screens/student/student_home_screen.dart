import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/opportunity_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/opportunity_card.dart';
import '../auth/login_screen.dart';
import 'my_applications_screen.dart';
import 'opportunity_details_screen.dart';
import 'student_profile_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final ScrollController scrollController = ScrollController();

  String selectedCategory = 'All';

  final List<Map<String, dynamic>> categories = const [
    {'title': 'All', 'icon': Icons.grid_view_rounded},
    {'title': 'Design', 'icon': Icons.design_services_outlined},
    {'title': 'Engineering', 'icon': Icons.engineering_outlined},
    {'title': 'Marketing', 'icon': Icons.campaign_outlined},
    {'title': 'Data', 'icon': Icons.analytics_outlined},
    {'title': 'Business', 'icon': Icons.business_center_outlined},
    {'title': 'Operations', 'icon': Icons.settings_suggest_outlined},
    {'title': 'Research', 'icon': Icons.manage_search_outlined},
  ];

  Future<void> logout() async {
    final provider = Provider.of<AppAuthProvider>(context, listen: false);
    await provider.logoutUser();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  void goHome() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void goApplications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyApplicationsScreen(),
      ),
    );
  }

  void goProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentProfileScreen(),
      ),
    );
  }

  void openOpportunity(OpportunityModel opportunity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OpportunityDetailsScreen(
          opportunity: opportunity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;
    final opportunityProvider = Provider.of<OpportunityProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: StreamBuilder<List<OpportunityModel>>(
        stream: opportunityProvider.getAllOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allOpportunities = snapshot.data ?? [];

          final filteredOpportunities = allOpportunities.where((opportunity) {
            final matchesCategory = selectedCategory == 'All' ||
                opportunity.category.toLowerCase() ==
                    selectedCategory.toLowerCase();

            return matchesCategory;
          }).toList();

          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                _buildStudentNavigation(),
                _buildHeroSection(user?.name ?? 'Student'),
                const SizedBox(height: 38),

                _buildSectionTitle(
                  title: 'Choose Your Category',
                  subtitle:
                      'Browse opportunities based on your skills, interest, and preferred area.',
                ),
                const SizedBox(height: 18),
                _buildCategoryGrid(),

                const SizedBox(height: 38),

                _buildSectionTitle(
                  title: 'Opportunities You May Be Interested In',
                  subtitle:
                      'Explore startup roles available for ALU students.',
                ),
                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: filteredOpportunities.isEmpty
                      ? const SizedBox(
                          height: 260,
                          child: EmptyStateWidget(
                            title: 'No opportunities found',
                            subtitle:
                                'Once startups post opportunities, they will appear here.',
                            icon: Icons.work_outline,
                          ),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 700;

                            if (isWide) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredOpportunities.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  mainAxisExtent: 175,
                                ),
                                itemBuilder: (context, index) {
                                  final opportunity =
                                      filteredOpportunities[index];

                                  return OpportunityCard(
                                    opportunity: opportunity,
                                    onTap: () => openOpportunity(opportunity),
                                  );
                                },
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredOpportunities.length,
                              itemBuilder: (context, index) {
                                final opportunity =
                                    filteredOpportunities[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: OpportunityCard(
                                    opportunity: opportunity,
                                    onTap: () => openOpportunity(opportunity),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentNavigation() {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            'STARTUPBRIDGE',
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 1.4,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const Spacer(),
          _navButton('Home', goHome),
          _navButton('My Applications', goApplications),
          _navButton('Profile', goProfile),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB800),
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(String text, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF555555),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeroSection(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 58, 24, 70),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1F4D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(90),
          bottomRight: Radius.circular(90),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Find Skills, Build Experience & Grow Opportunities',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Hello, $name \nFind Startup Roles That Match You',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              height: 1.15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Connect with ALU student-led startups and gain real-world experience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF17233C),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF8A8A8A),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final crossAxisCount = isWide ? 4 : 2;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: isWide ? 1.6 : 1.45,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category['title'];

              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  setState(() {
                    selectedCategory = category['title'];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF2D2D)
                          : Colors.transparent,
                      width: 1.6,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        color: const Color(0xFFFF6969),
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF17233C),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Open positions',
                        style: TextStyle(
                          color: Color(0xFF9A9A9A),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}