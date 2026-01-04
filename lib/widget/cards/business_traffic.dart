import 'package:flutter/material.dart';
import 'package:tp_flutter/utils/color.dart';

import '../../utils/text_style.dart';

class BusinessTrafficCard extends StatelessWidget {
  const BusinessTrafficCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> platforms = [
      {'name': 'Website', 'value': 10240.0, 'total': '10,24K', 'percent': '34.7%', 'up': true, 'color': Colors.orange, 'icon': Icons.language},
      {'name': 'Marketplace', 'value': 180, 'total': '180K', 'percent': '80.5%', 'up': true, 'color': Colors.green, 'icon': Icons.store},
      {'name': 'Retail POS', 'value': 80, 'total': '598', 'percent': '15.6%', 'up': false, 'color': Colors.red, 'icon': Icons.point_of_sale},
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isWide ? 20 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.fromBorderSide(BorderSide(color: AppColors.border))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, isWide),
              const SizedBox(height: 16),
              _trafficTarget(isWide, '240K'),
              const SizedBox(height: 8),
              _segmentedProgress(platforms),
              const SizedBox(height: 8),
              _platformsHeader(),
              const SizedBox(height: 8),
              ...platforms.map((a) => _platformRow(
                color: a['color'],
                icon: a['icon'],
                name: a['name'],
                value: a['total'],
                percent: a['percent'],
                up: a['up'],
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  // ================= HEADER =================

  Widget _header(BuildContext context, bool isWide) {
    double iconSize = isWide ? 32 : 24;
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
            Icons.warning_sharp,
            color: AppColors.chartOrange,
            size: iconSize,
          ),
        ),
        SizedBox(width:iconSize),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Traffics',
                style: AppTextStyles.cardTitle,
              ),
              SizedBox(height: w * 0.006),
              Text(
                'Keep an eye to your business orders',
                style: AppTextStyles.cardSubtitle,
              ),
            ],
          ),
        ),
        _buildHeaderIcon(context, Icons.more_vert, "Business Traffics"),
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

  // ================= TARGET =================

  Widget _trafficTarget(bool isWide, String currenTraf) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: isWide ? 14 : 12, color: Colors.black),
              children: [
                TextSpan(
                  text: currenTraf, // Le 240K en gras
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' / 500K TM traffic targets'),
              ],
            ),
          ),
        ),
        Text(
          '+5.2% vs yesterday',
          style: TextStyle(
            fontSize: isWide ? 13 : 12,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ================= SEGMENTED PROGRESS =================

  Widget _segmentedProgress(List<Map<String, dynamic>> platforms) {
    return LayoutBuilder(
      builder: (context, constraints) {

        // Calcul du nombre de barres total
        int totalBars = (constraints.maxWidth / 6).floor();
        double totalValue = platforms.fold(0, (sum, item) => sum + item['value']);

        // Algorithme pour garantir qu'on voit chaque couleur, au moins
        List<int> barsPerPlatform = [];
        int allocatedBars = 0;

        for (var i = 0; i < platforms.length; i++) {
          int count = ((platforms[i]['value'] / totalValue) * totalBars).floor();
          if (i == 0 && count < 10) count = 15;
          if (i == 1 && count < 6) count = 9;
          if (i == 2 && count < 3) count = 4;

          barsPerPlatform.add(count);
          allocatedBars += count;
        }

        while (allocatedBars > totalBars && totalBars > 0) {
          int maxIdx = barsPerPlatform.indexOf(barsPerPlatform.reduce((a, b) => a > b ? a : b));
          barsPerPlatform[maxIdx]--;
          allocatedBars--;
        }

        return SizedBox(
          height: 34,
          child: Row(
            children: [
              for (int i = 0; i < platforms.length; i++)
                ...List.generate(barsPerPlatform[i], (index) => Container(
                  width: 4,
                  height: 34,
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: platforms[i]['color'],
                    borderRadius: BorderRadius.circular(1),
                  ),
                )),
            ],
          ),
        );
      },
    );
  }


  // ================= TABLE HEADER =================
  Widget _platformsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Text(
              'Platforms',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              'Today',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  // ================= PLATFORM ROW =================
  Widget _platformRow({required Color color, required IconData icon, required String name, required String value, required String percent, required bool up,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  up ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: up ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 2),
                Text(
                  percent,
                  style: TextStyle(
                    fontSize: 12,
                    color: up ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
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
