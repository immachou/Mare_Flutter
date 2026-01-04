import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../utils/color.dart';
import '../../utils/text_style.dart';
import 'customer_sentiment_gauge.dart';

class CustomerSentimentCard extends StatelessWidget {
  const CustomerSentimentCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Écoute les changements du provider
    final sentiment = context.watch<DashboardProvider>().customerSentiment;

    // Couleurs exactes de l'image
    const colorPos = Color(0xFFD4813E);
    const colorNeu = Color(0xFFE5B58B);
    const colorNeg = Color(0xFFB0B8C1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        //border: Border.all(color: Colors.black.withOpacity(0.05)),
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 30),

          // ANIMATION AUTOMATIQUE VERS LE NOUVEAU SCORE
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
            tween: Tween<double>(begin: 0, end: sentiment.score),
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomPaint(
                    size: const Size(240, 120),
                    painter: CustomerSentimentGauge(
                      positive: sentiment.positive,
                      neutral: sentiment.neutral,
                      negative: sentiment.negative,
                    ),
                  ),
                  _buildScoreDisplay(value, colorPos),
                ],
              );
            },
          ),

          const SizedBox(height: 30),
          _buildStatsRow(sentiment, colorPos, colorNeu, colorNeg),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(double score, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: score.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const TextSpan(
                text: " / 5.0",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Text(
          "This month's score",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildStatsRow(sentiment, Color cPos, Color cNeu, Color cNeg) {
  return Container(
    // L'encadré gris clair autour des stats
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
    ),
    child: IntrinsicHeight( // Permet aux séparateurs de prendre toute la hauteur
      child: Row(
        children: [
          // Case Positive
          Expanded(child: _statItem("Positive", "${(sentiment.positive * 100).round()}%", cPos)),
          
          // Bordure verticale gauche
          VerticalDivider(color: Colors.black.withOpacity(0.05), width: 1, thickness: 1),
          
          // Case Neutral
          Expanded(child: _statItem("Neutral", "${(sentiment.neutral * 100).round()}%", cNeu)),
          
          // Bordure verticale droite
          VerticalDivider(color: Colors.black.withOpacity(0.05), width: 1, thickness: 1),
          
          // Case Negative
          Expanded(child: _statItem("Negative", "${(sentiment.negative * 100).round()}%", cNeg)),
        ],
      ),
    ),
  );
}

  Widget _statItem(String label, String value, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16), // Espace interne de la case
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu dans la case
          children: [
            // Petit carré au lieu du cercle
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2), // Carré légèrement arrondi

              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
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
            Icons.emoji_emotions,
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
                'Customer Sentiment',
                style: AppTextStyles.cardTitle,
              ),
              SizedBox(height: w * 0.006),
              Text(
                'Aggregated from emails + reviews + chats',
                style: AppTextStyles.cardSubtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }

}
