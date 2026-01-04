import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../utils/color.dart';

class EfficiencySlideCard extends StatefulWidget {
  const EfficiencySlideCard({super.key});

  @override
  State<EfficiencySlideCard> createState() => _EfficiencySlideCardState();
}

class _EfficiencySlideCardState extends State<EfficiencySlideCard> {
  int currentPage = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final slides = context.watch<DashboardProvider>().efficiencySlides;
    
    return Container(
      height: 175,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: slides.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildSlideCard(slides[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => _buildPageIndicator(index),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSlideCard(Map<String, dynamic> data) {
    clipBehavior: Clip.antiAlias;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.efficiencyStart,
            AppColors.efficiencyEnd,        
            Colors.white,                  
          ],
          stops: const [
            0.0,  
            0.85, 
            1.0,  
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 130, 128, 128).withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${data['value'].toStringAsFixed(0)}% ${data['label']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: [
              LayoutBuilder(builder: (context, constraint) {
                return Transform.translate(
                  offset: const Offset(0, 0),
                  child: SizedBox(
                    width: constraint.maxWidth + 40,
                    child: const Divider(
                      color: Colors.white38,
                      thickness: 0.8,
                      height: 20,
                    ),
                  ),
                );
              }),
              Row(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${data['growth']}% ${data['period']}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ]
          )

        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isActive = currentPage == index;
    final screenWidth = MediaQuery.of(context).size.width;

    // ici on récupère le nombre de slide dans le providers pour rendre dynamique tout ça
    final slidesCount = Provider.of<DashboardProvider>(context, listen: false).efficiencySlides.length;

    // ici on récupère l'espace disponible en prenant la largeur de l'ecran - la marge
    double dynamicWidth = (screenWidth - 80) / (slidesCount > 0 ? slidesCount : 1);

    // cette partie on a du reduire la taille du pageIndicator et rendre ça dynamique pour chaque taille d'ecran
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeIn,
      // width: isActive ? dynamicWidth.clamp(50.0, 70.0) : (dynamicWidth * 0.5).clamp(8.0, 30.0),
      width: dynamicWidth.clamp(50.0, 90.0),
      height: 2.5,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: isActive 
          ? Colors.grey.shade500 
          : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}