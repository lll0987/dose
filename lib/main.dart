import 'package:flutter/material.dart';
import 'package:pillo/app/core/data/providers/pill_provider.dart';
import 'package:pillo/app/core/data/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

import 'app/core/data/providers/plan_provider.dart';
import 'app/core/data/services/pill_service.dart';
import 'app/core/data/services/plan_service.dart';
import 'app/core/data/services/transaction_service.dart';
import 'app/core/themes/app_theme.dart';
import 'app/core/data/services/hive_service.dart';
import 'app/core/themes/theme_service.dart';
import 'app/screens/daily_screen.dart';
import 'app/screens/pill_screen.dart';
import 'app/screens/plan_screen.dart';
import 'app/screens/settings_screen.dart';
import 'app/widgets/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Hive
  final hiveService = HiveService();
  await hiveService.init();

  final pillService = PillService();
  final planService = PlanService();
  final transactionService = TransactionService();
  await pillService.init();
  await planService.init();
  await transactionService.init();

  final pillProvider = PillProvider(pillService);
  final planProvider = PlanProvider(planService);
  final transactionProvider = TransactionProvider(
    transactionService,
    pillProvider,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService(hiveService)),
        Provider(create: (_) => pillService),
        Provider(create: (_) => planService),
        Provider(create: (_) => transactionService),
        ChangeNotifierProvider(create: (_) => pillProvider),
        ChangeNotifierProvider(create: (_) => planProvider),
        ChangeNotifierProvider(create: (_) => transactionProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          theme: AppTheme.getTheme(seedColor: themeService.seedColor),
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const DailyScreen(),
    const PlanScreen(),
    const PillScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
