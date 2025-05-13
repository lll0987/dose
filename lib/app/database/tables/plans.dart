import 'package:drift/drift.dart';

import 'pills.dart';

class Plans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pillId => integer().references(Pills, #id)();
  BoolColumn get isEnabled => boolean()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  IntColumn get qty => integer()();
  TextColumn get unit => text().withLength(min: 1, max: 50)();
  IntColumn get numerator => integer().nullable()();
  IntColumn get denominator => integer().nullable()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text()();
  TextColumn get repeatValues => text()();
  TextColumn get repeatUnit => text()();
  TextColumn get startTime => text()();
  BoolColumn get isExactTime => boolean()();
  IntColumn get duration => integer().nullable()();
  TextColumn get durationUnit => text().nullable()();
  IntColumn get reminderValue => integer().nullable()();
  TextColumn get reminderUnit => text().nullable()();
  TextColumn get reminderMethod => text().nullable()();
}
