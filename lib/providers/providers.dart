import 'package:flutter/foundation.dart';
import '../models/dashboardModels.dart';

class DashboardProvider extends ChangeNotifier {
  // State
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  int _currentFunnelTabIndex = 0;
  int get currentFunnelTabIndex => _currentFunnelTabIndex;

  //on utilise une Map pour faire correspondre l'index(0,1,2)aux données
  final Map<int, ConversionMetrics> _funnelData = {
    0:ConversionMetrics(
      visitors:3218,
      addedToCart: 417,
      checkoutStarted: 184,
      completedOrders: 118,
     ),
    1:ConversionMetrics(
      visitors:1500,
      addedToCart: 200,
      checkoutStarted: 90,
      completedOrders: 50,
     ),
    2:ConversionMetrics(
      visitors:800,
      addedToCart: 100,
      checkoutStarted: 50,
      completedOrders: 30,
     ),
  
  };
  //Getter pour obtenir les données en fonction de l'onglet actif
  ConversionMetrics get currentFunnelMetrics => _funnelData[_currentFunnelTabIndex]!;

  CustomerSentiment _customerSentiment = const CustomerSentiment(
    posCount: 34,
    neuCount: 200,
    negCount: 45,
  );

  CustomerSentiment get customerSentiment => _customerSentiment;

  // Méthode pour mettre à jour depuis l'interface plus tard
  void updateCounts(int pos, int neu, int neg) {
    _customerSentiment = CustomerSentiment(
      posCount: pos,
      neuCount: neu,
      negCount: neg,
    );
    notifyListeners();
  }

  /// Update bottom navigation index
  void setNavIndex(int index) {
    if (_currentNavIndex != index) {
      _currentNavIndex = index;
      notifyListeners();
    }
  }

  /// Update funnel tab index
  void setFunnelTabIndex(int index) {
    if (_currentFunnelTabIndex != index) {
      _currentFunnelTabIndex = index;
      notifyListeners();
    }
  }

  // Données slide EFFICIENCY
  final List<Map<String, dynamic>> _efficiencySlides = [
    {
      'title': 'Business Autonomous Reports',
      'value': 92,
      'label': 'Efficiency',
      'growth': 24.2,
      'period': 'vs last week',
    },
    {
      'title': 'Active Users',
      'value': 320,
      'label': 'Users',
      'growth': 18.6,
      'period': 'vs last month',
    },
    {
      'title': 'Revenue Growth',
      'value': 156,
      'label': 'Revenue',
      'growth': 45.8,
      'period': 'vs last month',
    },
    {
      'title': 'Customer Satisfaction',
      'value': 4.8,
      'label': 'Rating',
      'growth': 12.3,
      'period': 'vs last quarter',
    },
  ];

  List<Map<String, dynamic>> get efficiencySlides => _efficiencySlides;

  // Données workflow performance
  final Map<String, dynamic> _workflowData = {
    'date': '05 December 25',
    'successRate': 98.0,
    'successGrowth': 16.2,
    'automationChange': -4.7,
    'revenueChange': 20.9,
  };

  Map<String, dynamic> get workflowData => _workflowData;
}
