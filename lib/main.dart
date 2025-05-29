import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app/database/app_database.dart';
import 'app/database/dao/pill_dao.dart';
import 'app/database/dao/plan_dao.dart';
import 'app/database/dao/transaction_dao.dart';
import 'app/database/repository/pill_repository.dart';
import 'app/database/repository/plan_repository.dart';
import 'app/database/repository/transaction_repository.dart';
import 'app/providers/datetime_provider.dart';
import 'app/providers/pill_provider.dart';
import 'app/providers/plan_provider.dart';
import 'app/providers/theme_provider.dart';
import 'app/providers/transaction_provider.dart';
import 'app/screens/home_screen.dart';
import 'app/screens/pill_screen.dart';
import 'app/screens/plan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final pillDao = PillDao(db);
  final planDao = PlanDao(db);
  final transactionDao = TransactionDao(db);
  final pillRepository = PillRepository(db, pillDao, planDao);
  final planRepository = PlanRepository(db, planDao, pillDao, transactionDao);
  final transactionRepository = TransactionRepository(
    db,
    transactionDao,
    pillDao,
  );

  final themeProvider = ThemeProvider();
  final datetimeProvider = DatetimeProvider();
  final pillProvider = PillProvider(pillRepository);
  final planProvider = PlanProvider(planRepository);
  final transactionProvider = TransactionProvider(
    transactionRepository,
    pillProvider,
    datetimeProvider,
  );

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
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => datetimeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Dose+',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('zh')],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeProvider.themeColor,
            ),
          ),
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
    const HomeScreen(),
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note),
            label: AppLocalizations.of(context)!.navPlan,
          ),
          NavigationDestination(
            icon: const Icon(Icons.medication),
            label: AppLocalizations.of(context)!.navPill,
          ),
        ],
      ),
    );
  }
}
