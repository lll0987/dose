import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'dao/pill_dao.dart';
import 'dao/plan_dao.dart';
import 'dao/transaction_dao.dart';
import 'tables/cycles.dart';
import 'tables/pills.dart';
import 'tables/plans.dart';
import 'tables/quantities.dart';
import 'tables/specs.dart';
import 'tables/transactions.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Pills, Specs, Plans, Cycles, Transactions, Quantities],
  daos: [PillDao, PlanDao, TransactionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dose',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
