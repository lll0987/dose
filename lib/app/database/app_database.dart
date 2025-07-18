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
import 'tables/revisions.dart';
import 'tables/specs.dart';
import 'tables/transactions.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Pills, Specs, Plans, Cycles, Transactions, Quantities, Revisions],
  daos: [PillDao, PlanDao, TransactionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(transactions, transactions.calcQty);
      }
      if (from < 3) {
        await migrator.addColumn(plans, plans.updateTime);
        await migrator.createTable(revisions);
        await migrator.addColumn(plans, plans.revisionId);
        await migrator.addColumn(cycles, cycles.revisionId);
        await migrator.addColumn(transactions, transactions.revisionId);
      }
      if (from < 4) {
        await migrator.addColumn(pills, pills.isNegative);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dose',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
