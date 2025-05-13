import 'package:drift/drift.dart';

import 'pills.dart';
import 'plans.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pillId => integer().references(Pills, #id)();
  IntColumn get planId => integer().nullable().references(Plans, #id)();
  BoolColumn get isNegative => boolean()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get remark => text().nullable()();
  BoolColumn get isCustom => boolean()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
}
