import '../../models/plan_model.dart';
import '../app_database.dart';
import '../dao/plan_dao.dart';

class PlanRepository {
  final AppDatabase _db;
  final PlanDao _planDao;

  PlanRepository(this._db, this._planDao);

  Future<List<PlanModel>> getAllPlans() {
    return _db.transaction(() {
      return _planDao.getAllPlans();
    });
  }

  Future<int> addPlan(PlanModel plan) {
    return _db.transaction(() {
      return _planDao.addPlan(plan);
    });
  }

  Future<bool> updatePlan(PlanModel plan) {
    return _db.transaction(() {
      return _planDao.updatePlan(plan);
    });
  }

  Future<void> deletePlan(int id) {
    return _db.transaction(() {
      return _planDao.deletePlan(id);
    });
  }
}
