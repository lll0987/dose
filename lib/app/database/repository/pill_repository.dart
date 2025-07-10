import '../../models/pill_model.dart';
import '../../utils/result.dart';
import '../app_database.dart';
import '../dao/pill_dao.dart';
import '../dao/plan_dao.dart';
import '../dao/transaction_dao.dart';

class PillRepository {
  final AppDatabase _db;
  final PillDao _pillDao;
  final PlanDao _planDao;
  final TransactionDao _transactionDao;

  PillRepository(this._db, this._pillDao, this._planDao, this._transactionDao);

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

  String? _handlePillQuantity(PillModel pill) {
    final i = pill.packSpecs.indexWhere(
      (p) => p.unit == pill.initialQuantity.unit,
    );
    if (i == -1) return '初始数量单位应在包装规格列表中';
    final total = pill.initialQuantity.qty * pill.getTotalQtyMultiple(i);
    pill.quantity.qty = total;
    pill.quantity.fraction.numerator = pill.initialQuantity.fraction.numerator;
    pill.quantity.fraction.denominator =
        pill.initialQuantity.fraction.denominator;
    return null;
  }

  Future<Result<int>> addPill(PillModel pill) async {
    final str = _handlePillQuantity(pill);
    if (str != null) return Result.failure(str);
    return _db.transaction(() async {
      final result = await _pillDao.addPill(pill);
      return Result.success(result);
    });
  }

  Future<Result<bool>> updatePill(PillModel pill) async {
    if (pill.id == null) return Result.failure('pill id is null');
    final hasPlan = await _planDao.hasPlanByPill(pill.id!);
    final hasTransaction = await _transactionDao.hasTransactionByPill(pill.id!);
    if (!hasPlan && !hasTransaction) {
      final str = _handlePillQuantity(pill);
      if (str != null) return Result.failure(str);
    }
    return _db.transaction(() async {
      final result = await _pillDao.updatePill(pill);
      return Result.success(result);
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
