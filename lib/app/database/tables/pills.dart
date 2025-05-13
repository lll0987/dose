import 'package:drift/drift.dart';

class Pills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get imagePath => text().nullable()();
  IntColumn get initialQty => integer()();
  TextColumn get initialUnit => text().withLength(min: 1, max: 50)();
  IntColumn get initialNum => integer().nullable()();
  IntColumn get initialDen => integer().nullable()();
  IntColumn get qty => integer()();
  IntColumn get numerator => integer().nullable()();
  IntColumn get denominator => integer().nullable()();
  TextColumn get preferredUnit => text().nullable()();
  IntColumn get themeValue => integer().nullable()();
}
