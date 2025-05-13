import '../../models/pill_model.dart';
import '../app_database.dart';
import '../dao/pill_dao.dart';

class PillRepository {
  final AppDatabase _db;
  final PillDao _pillDao;

  PillRepository(this._db, this._pillDao);

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

  Future<int> addPill(PillModel pill) {
    return _db.transaction(() {
      return _pillDao.addPill(pill);
    });
  }

  Future<bool> updatePill(PillModel pill) {
    return _db.transaction(() {
      return _pillDao.updatePill(pill);
    });
  }

  Future<void> deletePill(int id) {
    return _db.transaction(() {
      return _pillDao.deletePill(id);
    });
  }
}
