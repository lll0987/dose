import 'package:collection/collection.dart';

import '../../models/plan_model.dart';
import '../../models/transaction_model.dart';
import '../../utils/datetime.dart';
import '../app_database.dart';
import '../dao/plan_cache_dao.dart';
import '../dao/plan_dao.dart';
import '../dao/transaction_dao.dart';

class PlanCacheRepository {
  final AppDatabase _db;
  final PlanCacheDao _cacheDao;
  final PlanDao _planDao;
  final TransactionDao _transactionDao;

  PlanCacheRepository(
    this._db,
    this._cacheDao,
    this._planDao,
    this._transactionDao,
  );

  Future<void> _handlePlanCaches({
    required List<PlanCacheModel> caches,
    required DateTime startDate,
    required DateTime endDate,
    required List<TransactionModel> allTransactions,
    List<PlanModel>? planList,
    PlanModel? plan,
  }) async {
    assert(planList != null || plan != null);

    final list = plan == null ? planList! : [plan];
    List<PlanCacheModel> records = [];
    DateTime date = startDate.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    while (!date.isAfter(endDate)) {
      final str = getCacheFormatDate(date);
      for (var plan in list) {
        final cache = caches.firstWhereOrNull(
          (e) =>
              e.date == str &&
              e.planId == plan.id &&
              e.revisionId == plan.revisionId,
        );
        if (cache != null) continue;

        final transactions = getDayTransactions(
          plan.id!,
          plan.revisionId,
          date,
          allTransactions,
        );

        final status = await getPlanStatus(
          day: date,
          plan: plan,
          transactions: transactions,
        );

        final record = PlanCacheModel(
          planId: plan.id!,
          revisionId: plan.revisionId,
          date: str,
          status: status.name,
          qty: transactions.firstOrNull?.calcQty,
          start: transactions.firstOrNull?.startTime,
          end: transactions.firstOrNull?.endTime,
        );
        records.add(record);
        caches.add(record);
      }
      date = date.add(const Duration(days: 1));
    }

    await _db.transaction(() {
      return _cacheDao.addCaches(records);
    });
  }

  Future<List<PlanCacheModel>> getAllPlanCaches(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final planList = await _planDao.getAllRevisionPlans();
    final caches = await _cacheDao.getCaches(startDate, endDate);

    final length = endDate.difference(startDate).inDays * planList.length;
    if (caches.length == length) return caches;

    final allTransactions = await getAllTransactions(startDate, endDate);

    await _handlePlanCaches(
      startDate: startDate,
      endDate: endDate,
      planList: planList,
      caches: caches,
      allTransactions: allTransactions,
    );

    return caches;
  }

  Future<List<PlanCacheModel>> getPlanCaches({
    int? planId,
    required DateTime startDate,
    required DateTime endDate,
    PlanModel? plan,
  }) async {
    assert(planId != null || plan != null);

    final pid = planId ?? plan!.id!;
    plan ??= await _planDao.firstPlan(pid);

    final caches = await _cacheDao.getPlanCaches(pid, startDate, endDate);
    final length = endDate.difference(startDate).inDays;
    if (caches.length == length) return caches;

    final allTransactions = await getAllTransactions(startDate, endDate);

    await _handlePlanCaches(
      startDate: startDate,
      endDate: endDate,
      plan: plan,
      caches: caches,
      allTransactions: allTransactions,
    );

    return caches;
  }

  Future<int> updateCache(TransactionModel transaction) {
    final status = _getPlanStatusFromTransactions([transaction]);
    return _cacheDao.updateCache(
      planId: transaction.planId!,
      revisionId: transaction.revisionId,
      date: getCacheFormatDate(transaction.startTime),
      status: status.name,
      qty: transaction.calcQty,
      start: transaction.startTime,
      end: transaction.endTime,
    );
  }

  Future<List<TransactionModel>> getAllTransactions(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _transactionDao.getTransactions(
      startDate.subtract(const Duration(days: 1)),
      endDate,
      {},
    );
  }

  Future<List<TransactionModel>> getPlanTransactions(
    int planId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _transactionDao.getTransactions(
      startDate.subtract(const Duration(days: 1)),
      endDate,
      {planId: planId},
    );
  }

  List<TransactionModel> getDayTransactions(
    int planId,
    int? revisionId,
    DateTime day,
    List<TransactionModel> allTransactions,
  ) {
    return allTransactions
        .where(
          (t) =>
              t.planId == planId &&
              t.revisionId == revisionId &&
              (!t.startTime.isBefore(day)) &&
              t.startTime.isBefore(day.add(const Duration(days: 1))),
        )
        .toList();
  }

  // 计划状态
  Future<PlanStatus> getPlanStatus({
    required DateTime day,
    required PlanModel plan,
    List<TransactionModel>? transactions,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    /* 计划在当前日期不需要执行 */
    if (!plan.isActive(day)) {
      return PlanStatus.none;
    }

    // 获取需要的数据
    if (transactions == null) {
      assert(startDate != null && endDate != null);
      transactions = await getPlanTransactions(plan.id!, startDate!, endDate!);
    }

    return _getPlanStatusFromTransactions(transactions);
  }

  PlanStatus _getPlanStatusFromTransactions(
    List<TransactionModel> transactions,
  ) {
    /* 有执行记录，数量大于0 -> 已执行，数量等于0 -> 已补 */
    if (transactions.any((t) => t.quantities.isNotEmpty)) {
      return transactions.first.calcQty == '0'
          ? PlanStatus.supplemented
          : PlanStatus.taken;
    }

    /* 有忽略记录 */
    if (transactions.isNotEmpty) {
      return PlanStatus.ignored;
    }

    return PlanStatus.missed;
  }
}
