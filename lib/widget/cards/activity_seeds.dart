import 'package:flutter/material.dart';
import '../../models/dashboardModels.dart';
import '../../utils/color.dart';
import '../../utils/text_style.dart';

class ActivitiesCard extends StatelessWidget {
  final List<ActivityItem> activities;

  const ActivitiesCard({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          ...activities.map((item) => _buildActivityRow(item)),
        ],
      ),
    );
  }

  Widget _buildActivityRow(ActivityItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeading(item),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodySmall?.copyWith(
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: "${item.title} ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: item.highlight ?? ''),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                    item.timeAgo,
                    style: AppTextStyles.labelSmall?.copyWith(color: Colors.grey)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(ActivityItem item) {
    if (item.imagePath != null) {
      return CircleAvatar(
        backgroundImage: AssetImage(item.imagePath!),
        radius: 16,
      );
    }

    Object iconData = item.icon ?? Icons.notifications_none_rounded;
    Color iconColor = AppColors.primary;

    if (item.icon == null){
      switch (item.type) {
        case ActivityType.alert:
          iconColor = Colors.redAccent;
          iconData = Icons.warning_amber_rounded;
          break;
        case ActivityType.update:
          iconColor = Colors.blueAccent;
          iconData = Icons.sync;
          break;
        default:
          iconColor = AppColors.primary;
          iconData = Icons.notifications_none_rounded;
      }

    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData as IconData?,
        size: 18,
        color: iconColor,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.chartBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.smart_button, color: AppColors.chartOrange, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activities Feeds', style: AppTextStyles.cardTitle),
              const SizedBox(height: 2),
              Text('Stay updated with your business', style: AppTextStyles.cardSubtitle),
            ],
          ),
        ),
      ],
    );
  }
}
