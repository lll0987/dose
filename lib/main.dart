import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/database/app_database.dart';
import 'app/database/dao/pill_dao.dart';
import 'app/database/dao/plan_dao.dart';
import 'app/database/dao/transaction_dao.dart';
import 'app/database/repository/pill_repository.dart';
import 'app/database/repository/plan_repository.dart';
import 'app/database/repository/transaction_repository.dart';
import 'app/providers/pill_provider.dart';
import 'app/providers/plan_provider.dart';
import 'app/providers/transaction_provider.dart';
import 'app/screens/daily_screen.dart';
import 'app/screens/pill_screen.dart';
import 'app/screens/plan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final pillDao = PillDao(db);
  final planDao = PlanDao(db);
  final transactionDao = TransactionDao(db);
  final pillRepository = PillRepository(db, pillDao);
  final planRepository = PlanRepository(db, planDao);
  final transactionRepository = TransactionRepository(
    db,
    transactionDao,
    pillDao,
  );

  final pillProvider = PillProvider(pillRepository);
  final planProvider = PlanProvider(planRepository);
  final transactionProvider = TransactionProvider(transactionRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => db),
        Provider(create: (_) => pillRepository),
        Provider(create: (_) => planRepository),
        Provider(create: (_) => transactionRepository),
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
    return MaterialApp(
      title: 'Dose+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MainScreen(),
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '今日'),
          NavigationDestination(icon: Icon(Icons.event_note), label: '计划'),
          NavigationDestination(icon: Icon(Icons.medication), label: '药物'),
        ],
      ),
    );
  }
}
