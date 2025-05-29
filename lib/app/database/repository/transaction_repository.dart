import 'package:collection/collection.dart';

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

  Future<List<TransactionModel>> getDayTransactions(DateTime day) {
    return _db.transaction(() {
      return _transactionDao.getDayTransactions(day);
    });
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
      final quantity = QuantityModel.sumQuantities(quantities);

      final sign = transaction.isNegative ? -1 : 1;
      final result = QuantityModel.sumQuantities([
        pill.quantity,
        QuantityModel(
          qty: quantity.qty * sign,
          fraction: FractionModel(
            (quantity.fraction.numerator ?? 0) * sign,
            quantity.fraction.denominator,
          ),
        ),
      ]);

      transaction.calcQty = quantity.displayText;
      await _transactionDao.addTransaction(transaction);

      pill.quantity = result;
      await _pillDao.update1(pill.toPill()!);
    });
  }

  Future<Map<int, Map<int, List<int>>>> getYearTransactions(int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return _db.transaction(() async {
      final transactions = await _transactionDao.getQuantitiesTransactions(
        start,
        end,
      );
      final ids = transactions.map((e) => e.pillId).toList();
      final pills = await _pillDao.getPills(ids);
      final pillMap = groupBy(pills, (pill) => pill.id);

      Map<int, Map<int, List<int>>> result = {};
      for (var item in transactions) {
        final month = item.startTime.month;
        final day = item.startTime.day;
        final values =
            pillMap[item.pillId]!.map((p) => p.themeValue ?? -1).toList();

        // 如果没有这个月份，创建一个新的子 map
        result.putIfAbsent(month, () => {});

        // 获取当前月份下的日期 map
        var dayMap = result[month]!;

        // 将 pillData 添加到对应日期的列表中
        dayMap.putIfAbsent(day, () => []).addAll(values);
      }
      return result;
    });
  }

  Future<List<TransactionModel>> getTransactionHistoryByPill(int pillId) {
    return _db.transaction(() async {
      return _transactionDao.getTransactionHistoryByPill(pillId);
    });
  }

  Future<void> addTransactions(List<TransactionModel> transactions) {
    return _db.transaction(() async {
      await _transactionDao.addTransactions(transactions);
    });
  }
}
