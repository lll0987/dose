import '../../models/transaction_model.dart';
import '../app_database.dart';
import '../dao/pill_dao.dart';
import '../dao/transaction_dao.dart';

class TransactionRepository {
  final AppDatabase _db;
  final TransactionDao _transactionDao;
  final PillDao _pillDao;

  TransactionRepository(this._db, this._transactionDao, this._pillDao);

  Future<List<TransactionModel>> getTodayTransactions(DateTime today) {
    return _db.transaction(() {
      return _transactionDao.getTodayTransactions(today);
    });
  }

  Future<void> addTransaction(TransactionModel transaction) {
    return _db.transaction(() async {
      await _transactionDao.addTransaction(transaction);
      await _pillDao.updatePillQty(transaction);
    });
  }
}
