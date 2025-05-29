import 'package:drift/drift.dart';

import '../../models/pill_model.dart';
import '../../utils/result.dart';
import '../app_database.dart';
import '../tables/pills.dart';
import '../tables/specs.dart';

part 'pill_dao.g.dart';

@DriftAccessor(tables: [Pills, Specs])
class PillDao extends DatabaseAccessor<AppDatabase> with _$PillDaoMixin {
  PillDao(super.db);

  Future<bool> isEmpty() async {
    final result = await (select(pills)..limit(1)).getSingleOrNull();
    return result == null;
  }

  Future<List<SpecModel>> getAllSpecs(int pillId) async {
    final specList =
        await (select(specs)
              ..where((tbl) => tbl.pillId.equals(pillId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
    return specList.map((s) => SpecModel(qty: s.qty, unit: s.unit)).toList();
  }

  Future<void> insertSpecs(int pillId, List<SpecModel> packSpecs) {
    return batch((b) {
      b.insertAll(
        specs,
        packSpecs.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return SpecsCompanion(
            pillId: Value(pillId),
            orderIndex: Value(index),
            qty: Value(item.qty),
            unit: Value(item.unit),
          );
        }).toList(),
      );
    });
  }

  Future<void> deleteSpecs(int pillId) {
    return (delete(specs)..where((tbl) => tbl.pillId.equals(pillId))).go();
  }

  Future<List<Pill>> all() {
    return select(pills).get();
  }

  Future<int> add1(Insertable<Pill> entity) {
    return into(pills).insert(entity);
  }

  Future<bool> update1(Pill item) {
    return update(pills).replace(item);
  }

  Future<void> delete1(int id) {
    return (delete(pills)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<Pill>> getPills(List<int> ids) async {
    return await (select(pills)..where((tbl) => tbl.id.isIn(ids))).get();
  }

  Future<List<PillModel>> getAllPills() async {
    final allPills = await all();
    final List<PillModel> result = [];
    for (var pill in allPills) {
      final specList = await getAllSpecs(pill.id);
      result.add(PillModel.fromPill(pill, specList));
    }
    return result;
  }

  Future<PillModel> firstPill(int id) async {
    final pill =
        await (select(pills)..where((tbl) => tbl.id.equals(id))).getSingle();
    final specList = await getAllSpecs(pill.id);
    return PillModel.fromPill(pill, specList);
  }

  Future<Result<int>> addPill(PillModel pill) async {
    final i = pill.packSpecs.indexWhere(
      (p) => p.unit == pill.initialQuantity.unit,
    );
    if (i == -1) return Result.failure('初始数量单位应在包装规格列表中');
    final total = pill.initialQuantity.qty * pill.getTotalQtyMultiple(i);
    pill.quantity.qty = total;
    pill.quantity.fraction.numerator = pill.initialQuantity.fraction.numerator;
    pill.quantity.fraction.denominator =
        pill.initialQuantity.fraction.denominator;
    final id = await add1(pill.toCompanion());
    await insertSpecs(id, pill.packSpecs);
    return Result.success(id);
  }

  Future<bool> updatePill(PillModel pill) async {
    if (pill.id == null) return false;
    final r = await update1(pill.toPill()!);
    if (r == false) return false;
    await deleteSpecs(pill.id!);
    await insertSpecs(pill.id!, pill.packSpecs);
    return true;
  }

  Future<void> deletePill(int id) async {
    await delete1(id);
  }
}
