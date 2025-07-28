import 'package:collection/collection.dart';

import '../../models/pill_model.dart';
import '../../models/quantity_model.dart';
import '../../models/transaction_model.dart';
import '../app_database.dart';
import '../dao/pill_dao.dart';
import '../dao/transaction_dao.dart';
import 'plan_cache_repository.dart';

class TransactionRepository {
  final AppDatabase _db;
  final TransactionDao _transactionDao;
  final PillDao _pillDao;
  final PlanCacheRepository _cacheRepository;

  TransactionRepository(
    this._db,
    this._transactionDao,
    this._pillDao,
    this._cacheRepository,
  );

  Future<void> addTransaction(TransactionModel transaction) {
    return _db.transaction(() async {
      final pill = await _pillDao.firstPill(transaction.pillId);

      final quantity = _getSumQuantity(transaction.quantities, pill);

      transaction.calcQty = quantity?.displayText ?? '';
      await _transactionDao.addTransaction(transaction);

      await _cacheRepository.updateCache(transaction);

      if (quantity == null || quantity.decimalValue == 0) return;
      if (transaction.isNegative) {
        pill.quantity = pill.quantity - quantity;
      } else {
        pill.quantity = pill.quantity + quantity;
      }
      await _pillDao.update1(pill.toPill()!);
    });
  }

  Future<void> addTransactions(List<TransactionModel> transactions) {
    return _db.transaction(() async {
      final map = groupBy(transactions, (e) => e.pillId);
      for (final entry in map.entries) {
        final pill = await _pillDao.firstPill(entry.key);
        // final quantities = entry.value.expand((e) => e.quantities).toList();
        // final quantity = _getSumQuantity(quantities, pill);
        for (var transaction in entry.value) {
          final qty = _getSumQuantity(transaction.quantities, pill);
          transaction.calcQty = qty?.displayText ?? '';
          await _transactionDao.addTransaction(transaction);
          await _cacheRepository.updateCache(transaction);
          if (qty == null || qty.decimalValue == 0) continue;
          if (transaction.isNegative) {
            pill.quantity = pill.quantity - qty;
          } else {
            pill.quantity = pill.quantity + qty;
          }
        }
        await _pillDao.update1(pill.toPill()!);
      }
    });
  }

  QuantityModel? _getSumQuantity(
    List<QuantityModel> quantities,
    PillModel pill,
  ) {
    final qtys =
        quantities.map((q) {
          final index = pill.packSpecs.indexWhere((p) => p.unit == q.unit);
          return QuantityModel(
            qty: q.qty * pill.getTotalQtyMultiple(index),
            fraction: FractionModel(
              q.fraction.numerator,
              q.fraction.denominator,
            ),
          );
        }).toList();
    return QuantityModel.sum(qtys);
  }

  Future<List<Transaction>> getYearTransactions(int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return _transactionDao.getQuantitiesTransactions(start, end);
  }

  Future<List<TransactionModel>> getTransactionHistoryByPill(int pillId) {
    return _transactionDao.getTransactionHistoryByPill(pillId);
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
