import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter/providers/providers.dart';
import 'package:tp_flutter/screens/home_screen.dart';
import 'package:tp_flutter/theme/app_theme.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MareApp());
}

class MareApp extends StatelessWidget {
  const MareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Mare',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}





