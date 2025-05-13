import 'package:drift/drift.dart';

import 'transactions.dart';

class Quantities extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get qty => integer()();
  TextColumn get unit => text().withLength(min: 1, max: 50)();
  IntColumn get numerator => integer().nullable()();
  IntColumn get denominator => integer().nullable()();
}
