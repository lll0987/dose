import 'package:drift/drift.dart';

import '../../models/plan_model.dart';
import '../../utils/datetime.dart';
import '../app_database.dart';
import '../tables/cycles.dart';
import '../tables/plans.dart';
import '../tables/revisions.dart';

part 'plan_dao.g.dart';

@DriftAccessor(tables: [Plans, Cycles, Revisions])
class PlanDao extends DatabaseAccessor<AppDatabase> with _$PlanDaoMixin {
  PlanDao(super.db);

  Future<List<Cycle>> _allCycles(int planId, int? revisionId) {
    return (select(cycles)
          ..where(
            (tbl) =>
                tbl.planId.equals(planId) &
                (revisionId == null
                    ? tbl.revisionId.isNull()
                    : tbl.revisionId.equals(revisionId)),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
  }

  Future<List<CycleModel>> _getAllCycles(int planId, int? revisionId) async {
    final list = await _allCycles(planId, revisionId);
    return list
        .map((s) => CycleModel(value: s.value, unit: s.unit, isStop: s.isStop))
        .toList();
  }

  Future<void> _insertCycles(
    int planId,
    int revisionId,
    List<CycleModel> list,
  ) {
    return batch((b) {
      b.insertAll(
        cycles,
        list.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return CyclesCompanion(
            planId: Value(planId),
            revisionId: Value(revisionId),
            orderIndex: Value(index),
            value: Value(item.value),
            unit: Value(item.unit),
            isStop: Value(item.isStop),
          );
        }).toList(),
      );
    });
  }

  Future<void> _updateCycles(List<Cycle> list) {
    return batch((b) {
      b.replaceAll(cycles, list);
    });
  }

  Future<List<Plan>> all() {
    return select(plans).get();
  }

  Future<int> _add1(Insertable<Plan> entity) {
    return into(plans).insert(entity);
  }

  Future<bool> _update1(Plan item) {
    return update(plans).replace(item);
  }

  Future<void> delete1(int id) {
    return (delete(plans)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Plan> first(int id) async {
    return (select(plans)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<PlanModel> firstPlan(int id) async {
    final plan =
        await (select(plans)..where((tbl) => tbl.id.equals(id))).getSingle();
    final list = await _getAllCycles(id, plan.revisionId);
    return fromPlanToModel(plan, list);
  }

  Future<List<PlanModel>> getAllPlans() async {
    final allPlans = await all();
    final List<PlanModel> result = [];
    for (var item in allPlans) {
      final list = await _getAllCycles(item.id, item.revisionId);
      result.add(fromPlanToModel(item, list));
    }
    return result;
  }

  Future<List<PlanModel>> getAllRevisionPlans() async {
    final allPlans = await all();
    final ids = allPlans.map((e) => e.id).toList();
    final allRevisions =
        await (select(revisions)..where((tbl) => tbl.planId.isIn(ids))).get();
    final List<PlanModel> result = [];
    for (var item in allPlans) {
      final cycles = await _getAllCycles(item.id, item.revisionId);
      if (item.revisionId == null) {
        result.add(fromPlanToModel(item, cycles));
      } else {
        final list = allRevisions.where((e) => e.planId == item.id).toList();
        for (var row in list) {
          result.add(fromRevisionToPlan(row, item, cycles));
        }
      }
    }
    return result;
  }

  Future<int> addPlan(PlanModel plan) async {
    final id = await _add1(plan.toCompanion());
    final revisionId = await into(
      revisions,
    ).insert(plan.toRevision(planId: id));
    await _insertCycles(id, revisionId, plan.cycles);
    final item = plan.copyWith(id: id, revisionId: revisionId);
    await _update1(item.toPlan()!);
    return id;
  }

  Future<bool> updatePlan(PlanModel plan, bool isNew) async {
    final endDate = getFormatDate(
      DateTime.parse(plan.startDate).subtract(const Duration(days: 1)),
    );
    // 如果没有历史记录，将变更前的配置添加到历史记录
    if (plan.revisionId == null) {
      final record = await first(plan.id!);
      final revisionId = await into(
        revisions,
      ).insert(fromPlanToRevision(record).copyWith(endDate: Value(endDate)));
      final list = await _allCycles(record.id, null);
      await _updateCycles(
        list.map((e) => e.copyWith(revisionId: Value(revisionId))).toList(),
      );
    }
    if (isNew) {
      // 更新上一个版本的结束日期
      if (plan.revisionId != null) {
        await (update(revisions)..where(
          (tbl) => tbl.id.equals(plan.revisionId!),
        )).write(RevisionsCompanion(endDate: Value(endDate)));
      }
      // 创建新版本
      final revisionId = await into(revisions).insert(plan.toRevision());
      await _insertCycles(plan.id!, revisionId, plan.cycles);
      // 更新计划配置
      return await _update1(plan.copyWith(revisionId: revisionId).toPlan()!);
    } else {
      // 更新计划
      final p = plan.toPlan()!;
      final r = await _update1(p);
      if (!r) return false;
      if (plan.revisionId == null) return true;
      // 更新版本
      final count = await (update(revisions)..where(
        (tbl) => tbl.id.equals(plan.revisionId!),
      )).write(fromPlanToRevision(p));
      // 更新周期
      await (delete(cycles)..where(
        (tbl) => tbl.planId.equals(p.id) & tbl.revisionId.equals(p.revisionId!),
      )).go();
      await _insertCycles(p.id, p.revisionId!, plan.cycles);
      return count == 1;
    }
  }

  Future<void> deletePlan(int id) async {
    await delete1(id);
    await (delete(revisions)..where((tbl) => tbl.planId.equals(id))).go();
    await (delete(cycles)..where((tbl) => tbl.planId.equals(id))).go();
  }

  Future<void> disablePlan(int id, DateTime time) async {
    await (update(plans)..where((tbl) => tbl.id.equals(id))).write(
      PlansCompanion(isEnabled: Value(false), updateTime: Value(time.toUtc())),
    );
  }

  Future<void> enablePlan(int id, DateTime time) async {
    await (update(plans)..where((tbl) => tbl.id.equals(id))).write(
      PlansCompanion(isEnabled: Value(true), updateTime: Value(time.toUtc())),
    );
  }

  // 根据药物id获取是否有计划
  Future<bool> hasPlanByPill(int pillId) async {
    final result =
        await (select(plans)
              ..where((tbl) => tbl.pillId.equals(pillId))
              ..limit(1))
            .getSingleOrNull();
    return result != null;
  }
}
