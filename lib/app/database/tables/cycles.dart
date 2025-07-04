import 'package:drift/drift.dart';

import 'plans.dart';
import 'revisions.dart';

class Cycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get revisionId => integer().nullable().references(Revisions, #id)();
  IntColumn get planId => integer().references(Plans, #id)();
  IntColumn get value => integer()();
  TextColumn get unit => text().withLength(min: 1, max: 50)();
  BoolColumn get isStop => boolean()();
  IntColumn get orderIndex => integer()(); // 用于保持顺序
}
