import '../../models/pill_model.dart';
import '../../utils/result.dart';
import '../app_database.dart';
import '../dao/pill_dao.dart';
import '../dao/plan_dao.dart';

class PillRepository {
  final AppDatabase _db;
  final PillDao _pillDao;
  final PlanDao _planDao;

  PillRepository(this._db, this._pillDao, this._planDao);

  Future<bool> isEmpty() {
    return _pillDao.isEmpty();
  }

  Future<List<PillModel>> getAllPills() {
    return _db.transaction(() {
      return _pillDao.getAllPills();
    });
  }

  Future<PillModel> getPill(int id) {
    return _db.transaction(() {
      return _pillDao.firstPill(id);
    });
  }

  Future<Result<int>> addPill(PillModel pill) {
    return _db.transaction(() {
      return _pillDao.addPill(pill);
    });
  }

  Future<bool> updatePill(PillModel pill) {
    return _db.transaction(() {
      return _pillDao.updatePill(pill);
    });
  }

  Future<Result<void>> deletePill(int id) {
    return _db.transaction(() async {
      final r = await _planDao.hasPlanByPill(id);
      if (r) return Result.failure('此药物有计划，请先删除计划');
      await _pillDao.deletePill(id);
      return Result.success(null);
    });
  }
}
