import 'package:flutter/material.dart';

import '../models/opportunity_model.dart';

class OpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFE7E7),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getCategoryIcon(opportunity.category),
                  color: _getCategoryColor(opportunity.category),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF17233C),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      opportunity.startupName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFFF4D4D),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _smallInfo(
                      Icons.location_on_outlined,
                      opportunity.location,
                    ),
                    const SizedBox(height: 5),
                    _smallInfo(
                      Icons.schedule_outlined,
                      opportunity.type,
                    ),
                    const SizedBox(height: 5),
                    _smallInfo(
                      Icons.psychology_outlined,
                      opportunity.requiredSkills,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      opportunity.status == 'open' ? 'Open' : opportunity.status,
                      style: const TextStyle(
                        color: Color(0xFFFF4D4D),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'View →',
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFF777777),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'design':
        return Icons.design_services_outlined;
      case 'engineering':
        return Icons.engineering_outlined;
      case 'marketing':
        return Icons.campaign_outlined;
      case 'data':
        return Icons.analytics_outlined;
      case 'business':
        return Icons.business_center_outlined;
      case 'operations':
        return Icons.settings_suggest_outlined;
      case 'research':
        return Icons.manage_search_outlined;
      default:
        return Icons.work_outline;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'design':
        return Colors.purple;
      case 'engineering':
        return Colors.blue;
      case 'marketing':
        return Colors.orange;
      case 'data':
        return Colors.green;
      case 'business':
        return Colors.red;
      case 'operations':
        return Colors.teal;
      case 'research':
        return Colors.indigo;
      default:
        return Colors.deepPurple;
    }
  }
}