import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/providers.dart';
import '../../utils/color.dart';
import '../../utils/text_style.dart';

class WorkflowPerformanceCard extends StatelessWidget {
  const WorkflowPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DashboardProvider>().workflowData;
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.fromBorderSide(BorderSide(color: AppColors.border))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: w * 0.06),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildChart(data, w),
              Positioned(
                top: w * -0.03,
                right: w * 0.08,
                child: _buildStats(data, w),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(w * 0.015),
          decoration: BoxDecoration(
            color: AppColors.chartBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.moving,
            color: AppColors.chartOrange,
            size: w * 0.07,
          ),
        ),
        SizedBox(width: w * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workflow Performance',
                style: AppTextStyles.cardTitle,
              ),
              SizedBox(height: w * 0.006),
              Text(
                'Performance of your active automations',
                style: AppTextStyles.cardSubtitle,
              ),
            ],
          ),
        ),
        _buildHeaderIcon(context, Icons.more_vert, "Workflow Performance"),
      ],
    );
  }

  // J'ai extrait cette fonction de dashboard.dart
  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Enlève le message précédent s'il y en a un

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating, // Rend la snackbar flottante (arrondie)
        width: 200, // Largeur réduite pour l'effet "petit toast"
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // J'ai extrait cette fonction de dashboard.dart
  Widget _buildHeaderIcon(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () {
        _showToast(context, label); // Appelle le toast ici
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 18.5),
      ),
    );
  }


  Widget _buildStats(Map<String, dynamic> data, double w) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: w * 0.63),
      child: Container(
        padding: EdgeInsets.all(w * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data['date'],
              style: TextStyle(
                fontSize: w * 0.028,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data['successRate'].toInt()}% Success',
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: w * 0.015),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: w * 0.032,
                      color: AppColors.chartGreen,
                    ),
                    SizedBox(width: w * 0.01),
                    Text(
                      '${data['successGrowth']}%',
                      style: TextStyle(
                        fontSize: w * 0.03,
                        color: AppColors.chartGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: w * 0.022),

            Container(
              width: double.infinity,
              height: 0.7,
              color: AppColors.border,
            ),
            
            SizedBox(height: w * 0.022),
            _buildMiniMetric(
              'Automation',
              data['automationChange'],
              AppColors.chartRed,
              w,
            ),
            SizedBox(height: w * 0.015),
            _buildMiniMetric(
              'Revenue',
              data['revenueChange'],
              AppColors.chartGreen,
              w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMetric(String label, double value, Color color, double w) {
    final isPositive = value > 0;

    return Row(
      children: [
        Container(
          width: 3,
          height: w * 0.03,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: w * 0.015),
        Text(
          label,
          style: TextStyle(
            fontSize: w * 0.03,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: w * 0.032,
          color: isPositive ? AppColors.chartGreen : AppColors.chartRed,
        ),
        SizedBox(width: w * 0.005),
        Text(
          '${value.abs()}%',
          style: TextStyle(
            fontSize: w * 0.03,
            fontWeight: FontWeight.w600,
            color: isPositive ? AppColors.chartGreen : AppColors.chartRed,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(Map<String, dynamic> data, double w) {
    return SizedBox(
      height: w * 0.55,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 4,
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            horizontalInterval: 20,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              if (![0, 20, 60].contains(value.toInt())) {
                return const FlLine(strokeWidth: 0);
              }
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.12),
              strokeWidth: 1,
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 100,
                color: Colors.grey.withOpacity(0.4),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ],
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: w * 0.07,
                getTitlesWidget: (value, _) {
                  if (![0, 20, 60, 100].contains(value.toInt())) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: w * 0.025,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: w * 0.075,
                getTitlesWidget: (value, _) {
                  const days = ['Wed', 'Thu', 'Fri', 'Sat'];
                  if (value >= 1 && value <= 4 && value == value.toInt()) {
                    return Padding(
                      padding: EdgeInsets.only(top: w * 0.015),
                      child: Text(
                        days[value.toInt() - 1],
                        style: TextStyle(
                          fontSize: w * 0.028,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isStepLineChart: true,
              barWidth: 2,
              color: AppColors.chartOrange,
              spots: const [
                FlSpot(0.0, 16),
                FlSpot(0.25, 16),
                FlSpot(0.25, 60),
                FlSpot(1.5, 60),
                FlSpot(1.5, 6),
                FlSpot(2.5, 6),
                FlSpot(2.5, 100),
                FlSpot(3.7, 100),
                FlSpot(3.7, 106),
                FlSpot(4.0, 106),
              ],
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, _) => spot.x == 3.7 && spot.y == 100,
                getDotPainter: (_, __, ___, ____) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.chartOrange,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}