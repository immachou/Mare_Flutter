import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter/screens/dashboard.dart';
import '../providers/providers.dart';
import '../utils/color.dart';
import '../widget/common/app_drawer.dart';
import '../widget/common/custom_app_bar.dart';
import '../widget/common/custom_bottom_nav.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // On récupère le provider ici ou via un Consumer plus bas
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const CustomAppBar(showLogo: true),
      endDrawer: const AppDrawer(),
      body: IndexedStack(
        index: provider.currentNavIndex,
        children: const [
          // Vos pages ici, pour l'instant dashboardscreen seul puisque c'est ça le prof a demandé
          DashboardScreen(),
          Center(child: Text("Page 2")),
          Center(child: Text("Page 3")),
          Center(child: Text("Page 4")),
          Center(child: Text("Page 5")),
        ],
      )
          .animate(key: ValueKey(provider.currentNavIndex)) // AJOUT DE LA KEY ICI
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.02, end: 0),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: provider.currentNavIndex,
        onTap: provider.setNavIndex,
      ),
    );
  }
}

