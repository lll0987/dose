import 'package:drift/drift.dart';

import 'plans.dart';
import 'revisions.dart';

class PlanStatusCaches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(Plans, #id)();
  IntColumn get revisionId => integer().nullable().references(Revisions, #id)();
  TextColumn get date => text()(); // 格式: "20250405"
  TextColumn get status => text()();
  TextColumn get qty => text().nullable()();
  DateTimeColumn get start => dateTime().nullable()();
  DateTimeColumn get end => dateTime().nullable()();
}
