import 'package:drift/drift.dart';

import 'pills.dart';

class Specs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pillId => integer().references(Pills, #id)();
  IntColumn get qty => integer()();
  TextColumn get unit => text().withLength(min: 1, max: 50)();
  IntColumn get orderIndex => integer()(); // 用于保持顺序
}
