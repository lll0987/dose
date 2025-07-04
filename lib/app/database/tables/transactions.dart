import 'package:drift/drift.dart';

import 'pills.dart';
import 'plans.dart';
import 'revisions.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get revisionId => integer().nullable().references(Revisions, #id)();
  IntColumn get planId => integer().nullable().references(Plans, #id)();
  IntColumn get pillId => integer().references(Pills, #id)();
  TextColumn get calcQty => text().withDefault(const Constant(""))();
  BoolColumn get isNegative => boolean()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get remark => text().nullable()();
  BoolColumn get isCustom => boolean()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
}
