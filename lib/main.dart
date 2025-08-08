import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app/database/app_database.dart';
import 'app/database/dao/pill_dao.dart';
import 'app/database/dao/plan_cache_dao.dart';
import 'app/database/dao/plan_dao.dart';
import 'app/database/dao/transaction_dao.dart';
import 'app/database/repository/pill_repository.dart';
import 'app/database/repository/plan_cache_repository.dart';
import 'app/database/repository/plan_repository.dart';
import 'app/database/repository/transaction_repository.dart';
import 'app/providers/daily_provider.dart';
import 'app/providers/language_provider.dart';
import 'app/providers/pill_provider.dart';
import 'app/providers/plan_provider.dart';
import 'app/providers/setting_provider.dart';
import 'app/providers/theme_provider.dart';
import 'app/providers/transaction_provider.dart';
import 'app/screens/daily_screen.dart';
import 'app/screens/history_screen.dart';
import 'app/screens/pill_screen.dart';
import 'app/screens/plan_screen.dart';
import 'app/service/loading_service.dart';
import 'app/widgets/loading_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  final languageProvider = LanguageProvider();
  final settingProvider = SettingProvider();

  final db = AppDatabase();
  final pillDao = PillDao(db);
  final planDao = PlanDao(db);
  final transactionDao = TransactionDao(db);
  final planCacheDao = PlanCacheDao(db);

  final pillRepository = PillRepository(db, pillDao, planDao, transactionDao);
  final planRepository = PlanRepository(
    db,
    planDao,
    pillDao,
    planCacheDao,
    transactionDao,
  );
  final planCacheRepository = PlanCacheRepository(
    db,
    planCacheDao,
    planDao,
    transactionDao,
  );
  final transactionRepository = TransactionRepository(
    db,
    transactionDao,
    pillDao,
    planCacheRepository,
  );

  final planProvider = PlanProvider(planRepository);
  final pillProvider = PillProvider(pillRepository, planProvider);
  final dailyProvider = DailyProvider(
    planCacheRepository,
    transactionRepository,
    planProvider,
    pillProvider,
  );
  final transactionProvider = TransactionProvider(
    transactionRepository,
    pillProvider,
    dailyProvider,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => db),
        Provider(create: (_) => pillRepository),
        Provider(create: (_) => planRepository),
        Provider(create: (_) => transactionRepository),
        ChangeNotifierProvider(create: (_) => themeProvider..init()),
        ChangeNotifierProvider(create: (_) => languageProvider..init()),
        ChangeNotifierProvider(create: (_) => settingProvider..init()),
        ChangeNotifierProvider(create: (_) => pillProvider..loadPills()),
        ChangeNotifierProvider(create: (_) => planProvider..loadPlans()),
        ChangeNotifierProvider(create: (_) => transactionProvider),
        ChangeNotifierProvider(create: (_) => dailyProvider..initData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'Dose+',
          locale: languageProvider.locale, // 关键：使用自定义 locale
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
              brightness: Brightness.light,
              // dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeProvider.themeColor,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const App(),
        );
      },
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loadingService.isLoading,
      builder: (context, isLoading, child) {
        return LoadingOverlay(isLoading: isLoading, child: child!);
      },
      child: const MainScreen(),
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
    const HistoryScreen(),
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
            label: AppLocalizations.of(context)!.navDaily,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month),
            label: AppLocalizations.of(context)!.navHistory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.dataset),
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
