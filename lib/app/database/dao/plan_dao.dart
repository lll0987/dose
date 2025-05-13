import 'package:drift/drift.dart';

import '../../models/plan_model.dart';
import '../app_database.dart';
import '../tables/cycles.dart';
import '../tables/plans.dart';

part 'plan_dao.g.dart';

@DriftAccessor(tables: [Plans, Cycles])
class PlanDao extends DatabaseAccessor<AppDatabase> with _$PlanDaoMixin {
  PlanDao(super.db);

  Future<List<CycleModel>> getAllCycles(int planId) async {
    final list =
        await (select(cycles)
              ..where((tbl) => tbl.planId.equals(planId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
    return list
        .map((s) => CycleModel(value: s.value, unit: s.unit, isStop: s.isStop))
        .toList();
  }

  Future<void> insertCycles(int planId, List<CycleModel> list) {
    return batch((b) {
      b.insertAll(
        cycles,
        list.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return CyclesCompanion(
            planId: Value(planId),
            orderIndex: Value(index),
            value: Value(item.value),
            unit: Value(item.unit),
            isStop: Value(item.isStop),
          );
        }).toList(),
      );
    });
  }

  Future<void> deleteCycles(int planId) {
    return (delete(cycles)..where((tbl) => tbl.planId.equals(planId))).go();
  }

  Future<List<Plan>> all() {
    return select(plans).get();
  }

  Future<int> add1(Insertable<Plan> entity) {
    return into(plans).insert(entity);
  }

  Future<bool> update1(Plan item) {
    return update(plans).replace(item);
  }

  Future<void> delete1(int id) {
    return (delete(plans)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<PlanModel>> getAllPlans() async {
    final allPlans = await all();
    final List<PlanModel> result = [];
    for (var item in allPlans) {
      final list = await getAllCycles(item.id);
      result.add(PlanModel.fromPlan(item, list));
    }
    return result;
  }

  Future<int> addPlan(PlanModel plan) async {
    final id = await add1(plan.toCompanion());
    await insertCycles(id, plan.cycles);
    return id;
  }

  Future<bool> updatePlan(PlanModel plan) async {
    if (plan.id == null) return false;
    final r = await update1(plan.toPlan()!);
    if (r == false) return false;
    await deleteCycles(plan.id!);
    await insertCycles(plan.id!, plan.cycles);
    return true;
  }

  Future<void> deletePlan(int id) async {
    await delete1(id);
  }
}
