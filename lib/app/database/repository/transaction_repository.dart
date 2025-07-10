import '../../models/quantity_model.dart';
import '../../models/transaction_model.dart';
import '../app_database.dart';
import '../dao/pill_dao.dart';
import '../dao/transaction_dao.dart';

class TransactionRepository {
  final AppDatabase _db;
  final TransactionDao _transactionDao;
  final PillDao _pillDao;

  TransactionRepository(this._db, this._transactionDao, this._pillDao);

  Future<int> countTransactions() {
    return _transactionDao.count();
  }

  Future<void> addTransaction(TransactionModel transaction) {
    return _db.transaction(() async {
      final pill = await _pillDao.firstPill(transaction.pillId);

      final quantities =
          transaction.quantities.map((q) {
            final index = pill.packSpecs.indexWhere((p) => p.unit == q.unit);
            return QuantityModel(
              qty: q.qty * pill.getTotalQtyMultiple(index),
              fraction: FractionModel(
                q.fraction.numerator,
                q.fraction.denominator,
              ),
            );
          }).toList();
      final quantity = QuantityModel.sum(quantities);

      transaction.calcQty = quantity?.displayText ?? '';
      await _transactionDao.addTransaction(transaction);

      if (quantity != null) {
        if (transaction.isNegative) {
          pill.quantity = pill.quantity - quantity;
        } else {
          pill.quantity = pill.quantity + quantity;
        }
      }
      await _pillDao.update1(pill.toPill()!);
    });
  }

  Future<List<Transaction>> getYearTransactions(int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return _transactionDao.getQuantitiesTransactions(start, end);
  }

  Future<List<TransactionModel>> getTransactions(DateTime start, DateTime end) {
    return _transactionDao.getTransactions(start, end);
  }

  Future<List<TransactionModel>> getTransactionHistoryByPill(int pillId) {
    return _transactionDao.getTransactionHistoryByPill(pillId);
  }

  Future<void> addTransactions(List<TransactionModel> transactions) {
    return _transactionDao.addTransactions(transactions);
  }

  Future<void> deleteTransactionFromPlan(int planId, DateTime date) {
    return _transactionDao.deleteTransactionFromPlan(planId, date);
  }

  Future<Transaction?> getLastTransactionByPlan(int planId) {
    return _transactionDao.getLastTransactionByPlan(planId);
  }

  Future<bool> hasTransactionByPill(int pillId) {
    return _transactionDao.hasTransactionByPill(pillId);
  }
}
