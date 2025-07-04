import '../../models/plan_model.dart';
import '../../utils/result.dart';
import '../app_database.dart';
import '../dao/pill_dao.dart';
import '../dao/plan_dao.dart';
import '../dao/transaction_dao.dart';

class PlanRepository {
  final AppDatabase _db;
  final PlanDao _planDao;
  final PillDao _pillDao;
  final TransactionDao _transactionDao;

  PlanRepository(this._db, this._planDao, this._pillDao, this._transactionDao);

  Future<List<PlanModel>> getAllPlans() {
    return _db.transaction(() {
      return _planDao.getAllPlans();
    });
  }

  Future<List<PlanModel>> getAllRevisionPlans() {
    return _planDao.getAllRevisionPlans();
  }

  Future<int> addPlan(PlanModel plan) {
    return _db.transaction(() {
      return _planDao.addPlan(plan);
    });
  }

  Future<bool> updatePlan(PlanModel plan, bool isNew) {
    // 提醒设置如果变更为不提醒，二次确认是否删除日历事件
    return _db.transaction(() async {
      return _planDao.updatePlan(plan, isNew);
    });
  }

  Future<Result<void>> deletePlan(int id) {
    return _db.transaction(() async {
      final r = await _transactionDao.hasTransactionByPlan(id);
      if (r) return Result.failure('此计划有执行记录，不允许删除！如果不再使用可以停用此计划。');
      await _planDao.deletePlan(id);
      return Result.success(null);
    });
  }

  // NEXT 停用启用时设置生效时间
  Future<void> disablePlan(int id) {
    final now = DateTime.now();
    return _db.transaction(() {
      return _planDao.disablePlan(id, now);
    });
  }

  Future<void> enablePlan(int id) {
    final now = DateTime.now();
    return _db.transaction(() {
      return _planDao.enablePlan(id, now);
    });
  }

  Future<List<PlanItemModel>> getPlanItems() {
    return _db.transaction(() async {
      final allPlans = await _planDao.all();
      final allPills = await _pillDao.getPills(
        allPlans.map((e) => e.pillId).toList(),
      );
      return allPlans.map((plan) {
        final pill = allPills.firstWhere((pill) => pill.id == plan.pillId);
        return PlanItemModel(
          id: plan.id,
          pillId: pill.id,
          text: '${pill.name}, ${plan.name}',
          startTime: plan.startTime,
        );
      }).toList();
    });
  }
}
