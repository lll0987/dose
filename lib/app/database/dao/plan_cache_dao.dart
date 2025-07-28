import 'package:drift/drift.dart';

import '../../models/plan_model.dart';
import '../../utils/datetime.dart';
import '../app_database.dart';
import '../tables/plan_status_cache.dart';

part 'plan_cache_dao.g.dart';

@DriftAccessor(tables: [PlanStatusCaches])
class PlanCacheDao extends DatabaseAccessor<AppDatabase>
    with _$PlanCacheDaoMixin {
  PlanCacheDao(super.db);

  Future<List<PlanCacheModel>> getCaches(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final min = getCacheFormatDate(startDate);
    final max = getCacheFormatDate(endDate);
    final records =
        await (select(planStatusCaches)
          ..where((tbl) => tbl.date.isBetweenValues(min, max))).get();
    return records.map((e) => PlanCacheModel.fromPlanStatusCache(e)).toList();
  }

  Future<List<PlanCacheModel>> getPlanCaches(
    int planId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final min = getCacheFormatDate(startDate);
    final max = getCacheFormatDate(endDate);
    final records =
        await (select(planStatusCaches)..where(
          (tbl) =>
              tbl.date.isBetweenValues(min, max) & tbl.planId.equals(planId),
        )).get();
    return records.map((e) => PlanCacheModel.fromPlanStatusCache(e)).toList();
  }

  Future<void> addCaches(List<PlanCacheModel> caches) {
    return batch((batch) {
      return batch.insertAll(
        planStatusCaches,
        caches.map(
          (e) => PlanStatusCachesCompanion(
            planId: Value(e.planId),
            revisionId: Value(e.revisionId),
            date: Value(e.date),
            status: Value(e.status),
            qty: Value(e.qty),
            start: Value(e.start),
            end: Value(e.end),
          ),
        ),
      );
    });
  }

  Future<int> updateCache({
    int? revisionId,
    required int planId,
    required String date,
    required String status,
    String? qty,
    DateTime? start,
    DateTime? end,
  }) {
    return (update(planStatusCaches)..where(
      (tbl) =>
          tbl.planId.equals(planId) &
          tbl.date.equals(date) &
          (revisionId == null
              ? tbl.revisionId.isNull()
              : tbl.revisionId.equals(revisionId)),
    )).write(
      PlanStatusCachesCompanion(
        status: Value(status),
        qty: Value(qty),
        start: Value(start),
        end: Value(end),
      ),
    );
  }

  Future<void> deleteCaches(
    int planId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final min = startDate.year * 10000 + startDate.month * 100 + startDate.day;
    final max = endDate.year * 10000 + endDate.month * 100 + endDate.day;
    await batch((batch) {
      batch.deleteWhere(
        planStatusCaches,
        (tbl) =>
            tbl.date.isBetweenValues('$min', '$max') &
            tbl.planId.equals(planId),
      );
    });
  }

  Future<void> deleteAllCaches(int planId) async {
    await batch((batch) {
      batch.deleteWhere(planStatusCaches, (tbl) => tbl.planId.equals(planId));
    });
  }
}
