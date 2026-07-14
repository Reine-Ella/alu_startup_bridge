import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/opportunity_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../auth/login_screen.dart';
import 'applicants_screen.dart';
import 'post_opportunity_screen.dart';
import 'startup_profile_screen.dart';

class StartupDashboardScreen extends StatefulWidget {
  const StartupDashboardScreen({super.key});

  @override
  State<StartupDashboardScreen> createState() => _StartupDashboardScreenState();
}

class _StartupDashboardScreenState extends State<StartupDashboardScreen> {
  final ScrollController scrollController = ScrollController();

  Future<void> logout(BuildContext context) async {
    final provider = Provider.of<AppAuthProvider>(context, listen: false);
    await provider.logoutUser();

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  void goHome() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void goPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PostOpportunityScreen(),
      ),
    );
  }

  void goApplicants() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ApplicantsScreen(),
      ),
    );
  }

  void goProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StartupProfileScreen(),
      ),
    );
  }

  Future<void> deleteOpportunity(String opportunityId) async {
    final provider = Provider.of<OpportunityProvider>(context, listen: false);

    await provider.deleteOpportunity(opportunityId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opportunity deleted successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            _buildHeroSection(user?.name ?? 'Startup'),
            _buildServicesSection(),
            _buildMyPostedOpportunities(),
            _buildWorkflowSection(),
            _buildCallToActionSection(),
            _buildFooter(),
          ],
        ),
      ),
      bottomNavigationBar: _buildStartupBottomNavigation(),
    );
  }

  Widget _buildStartupBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6C35FF),
        unselectedItemColor: const Color(0xFF555555),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        onTap: (index) {
          if (index == 0) {
            goHome();
          } else if (index == 1) {
            goPost();
          } else if (index == 2) {
            goApplicants();
          } else if (index == 3) {
            goProfile();
          } else if (index == 4) {
            logout(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Applicants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(String startupName) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF4EFEF),
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 64),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 760;

          final textSide = Column(
            crossAxisAlignment:
                isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Text(
                'Hello, $startupName ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Grow your startup\nwith ALU talent.',
                style: TextStyle(
                  fontSize: 43,
                  height: 1.08,
                  color: Color(0xFF1D1D1F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              const SizedBox(
                width: 500,
                child: Text(
                  'Post opportunities, review applicants, and connect with skilled ALU students who can support your startup.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment:
                    isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: goPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'POST OPPORTUNITY',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  OutlinedButton(
                    onPressed: goApplicants,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFF1D1D1F)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'VIEW APPLICANTS',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          );

          final imageSide = Container(
            height: 320,
            width: 420,
            color: Colors.white,
            child: const Center(
              child: Icon(
                Icons.rocket_launch_outlined,
                size: 110,
                color: Color(0xFFFFB800),
              ),
            ),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(child: textSide),
                const SizedBox(width: 40),
                imageSide,
              ],
            );
          }

          return Column(
            children: [
              textSide,
              const SizedBox(height: 30),
              imageSide,
            ],
          );
        },
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {
        'title': 'Post Roles',
        'icon': Icons.post_add_outlined,
        'onTap': goPost,
      },
      {
        'title': 'Applicants',
        'icon': Icons.people_outline,
        'onTap': goApplicants,
      },
      {
        'title': 'Profile',
        'icon': Icons.business_center_outlined,
        'onTap': goProfile,
      },
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF4EFEF),
      padding: const EdgeInsets.fromLTRB(32, 45, 32, 60),
      child: Column(
        children: [
          const Text(
            'Our Startup Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Manage opportunities, applications, and startup workflows.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF777777)),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 760;
              final crossAxisCount = isWide ? 3 : 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: isWide ? 1.6 : 3.2,
                ),
                itemBuilder: (context, index) {
                  final item = services[index];

                  return InkWell(
                    onTap: item['onTap'] as VoidCallback,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            color: const Color(0xFFFFB800),
                            size: 32,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1D1F),
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
        ],
      ),
    );
  }

  Widget _buildMyPostedOpportunities() {
    final user = Provider.of<AppAuthProvider>(context).currentUserProfile;
    final opportunityProvider = Provider.of<OpportunityProvider>(context);

    if (user == null) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 70),
      child: Column(
        children: [
          const Text(
            'My Posted Opportunities',
            style: TextStyle(
              fontSize: 26,
              color: Color(0xFF1D1D1F),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'These are the opportunities you have created for students.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF777777)),
          ),
          const SizedBox(height: 34),
          StreamBuilder<List<OpportunityModel>>(
            stream: opportunityProvider.getOpportunitiesByStartup(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                );
              }

              final opportunities = snapshot.data ?? [];

              if (opportunities.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EFEF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.work_outline,
                        size: 56,
                        color: Color(0xFFFFB800),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No opportunities posted yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Click “Post Opportunity” to create your first role.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF777777)),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: goPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB800),
                          foregroundColor: Colors.black,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Post Opportunity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 760;

                  if (isWide) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: opportunities.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        mainAxisExtent: 245,
                      ),
                      itemBuilder: (context, index) {
                        return _postedOpportunityCard(opportunities[index]);
                      },
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: opportunities.length,
                    itemBuilder: (context, index) {
                      return _postedOpportunityCard(opportunities[index]);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _postedOpportunityCard(OpportunityModel opportunity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            opportunity.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.startupName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFFFB800),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _smallChip(opportunity.category),
              _smallChip(opportunity.location),
              _smallChip(opportunity.type),
              _smallChip(opportunity.status),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Skills: ${opportunity.requiredSkills}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF777777)),
          ),
          const Spacer(),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: goApplicants,
                icon: const Icon(Icons.people_outline),
                label: const Text('Applicants'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0B1F4D),
                  side: const BorderSide(color: Color(0xFF0B1F4D)),
                ),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed: () => deleteOpportunity(opportunity.id),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF555555),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildWorkflowSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 70),
      child: Column(
        children: [
          const Text(
            'Manage Your Startup Workflow',
            style: TextStyle(
              fontSize: 26,
              color: Color(0xFF1D1D1F),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Post roles, review applicants, and update application progress.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF777777)),
          ),
          const SizedBox(height: 34),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 760;

              final postCard = _workflowCard(
                icon: Icons.add_circle_outline,
                title: 'Post Opportunity',
                description:
                    'Create new internship, volunteer, or project-based opportunities.',
                buttonText: 'Post Now',
                onTap: goPost,
              );

              final applicantsCard = _workflowCard(
                icon: Icons.people_alt_outlined,
                title: 'View Applicants',
                description:
                    'Review student applications and update their status.',
                buttonText: 'View Applicants',
                onTap: goApplicants,
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: postCard),
                    const SizedBox(width: 18),
                    Expanded(child: applicantsCard),
                  ],
                );
              }

              return Column(
                children: [
                  postCard,
                  const SizedBox(height: 18),
                  applicantsCard,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _workflowCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      color: const Color(0xFFF4EFEF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFFB800), size: 42),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF777777),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB800),
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFB800),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 50),
      child: Column(
        children: [
          const Text(
            'Let’s find the right student talent together!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Post your next opportunity and connect with students ready to contribute.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF3A3A3A)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: goPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            ),
            child: const Text(
              'POST AN OPPORTUNITY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 34),
      child: const Column(
        children: [
          Text(
            'STARTUPBRIDGE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Helping ALU startups connect with student talent.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}