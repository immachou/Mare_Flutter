import 'package:flutter/cupertino.dart';

class ActivityItem {
  final ActivityType type;
  final String title;
  final String? highlight;
  final String? imagePath;
  final String timeAgo;
  final IconData? icon;

  const ActivityItem({
    required this.type,
    required this.title,
    this.highlight,
    this.imagePath,
    required this.timeAgo,
    this.icon,
  });
}

enum ActivityType {
  aiGenerated,
  userAction,
  workflow,
  alert, update,
}

class ConversionMetrics {
  final int visitors;
  final int addedToCart;
  final int checkoutStarted;
  final int completedOrders;
  double get conversionRate => visitors == 0 ? 0.0 : (completedOrders / visitors) * 100;
  const ConversionMetrics({
    required this.visitors,
    required this.addedToCart,
    required this.checkoutStarted,
    required this.completedOrders,
  });
}

class CustomerSentiment {
  final int posCount;
  final int neuCount;
  final int negCount;


  int get totalReviews => posCount + neuCount + negCount;

  // Calcul automatique des pourcentages (0.0 à 1.0)
  double get positive => totalReviews == 0 ? 0.0 : posCount / totalReviews;
  double get neutral => totalReviews == 0 ? 0.0 : neuCount / totalReviews;
  double get negative => totalReviews == 0 ? 0.0 : negCount / totalReviews;


  double get score {
    if (totalReviews == 0) return 0.0;
    double calculated = (positive * 5.0) + (neutral * 2.5);
    return double.parse(calculated.toStringAsFixed(1));
  }

  const CustomerSentiment({
    required this.posCount,
    required this.neuCount,
    required this.negCount,
  });
}