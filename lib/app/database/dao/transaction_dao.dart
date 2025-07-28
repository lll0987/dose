import 'package:drift/drift.dart';

import '../../models/quantity_model.dart';
import '../../models/transaction_model.dart';
import '../app_database.dart';
import '../tables/quantities.dart';
import '../tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Quantities])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<List<QuantityModel>> getAllQuantities(int transactionId) async {
    final list =
        await (select(quantities)
          ..where((tbl) => tbl.transactionId.equals(transactionId))).get();
    return list.map((s) => QuantityModel.fromQuantity(s)).toList();
  }

  Future<void> insertQuantities(int transactionId, List<QuantityModel> list) {
    assert(list.every((e) => e.unit != null));
    return batch((b) {
      b.insertAll(
        quantities,
        list
            .map(
              (item) => QuantitiesCompanion(
                transactionId: Value(transactionId),
                qty: Value(item.qty),
                unit: Value(item.unit!),
                numerator: Value(item.fraction.numerator),
                denominator: Value(item.fraction.denominator),
              ),
            )
            .toList(),
      );
    });
  }

  Future<void> deleteQuantities(int transactionId) {
    return (delete(quantities)
      ..where((tbl) => tbl.transactionId.equals(transactionId))).go();
  }

  Future<List<Transaction>> all() {
    return select(transactions).get();
  }

  Future<int> _add1(Insertable<Transaction> entity) {
    return into(transactions).insert(entity);
  }

  Future<bool> update1(Transaction item) {
    return update(transactions).replace(item);
  }

  Future<void> delete1(int id) {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> count() {
    return count();
  }

  Future<int> addTransaction(TransactionModel transaction) async {
    transaction.timestamp = DateTime.now();
    final id = await _add1(transaction.toCompanion());
    await insertQuantities(id, transaction.quantities);
    return id;
  }

  // 根据计划id获取是否有记录
  Future<bool> hasTransactionByPlan(int planId) async {
    final list =
        await (select(transactions)
          ..where((tbl) => tbl.planId.equals(planId))).get();
    final ids = list.map((e) => e.id).toList();
    final result =
        await (select(quantities)
              ..where((tbl) => tbl.transactionId.isIn(ids))
              ..limit(1))
            .getSingleOrNull();
    return result != null;
  }

  // 根据药物id获取是否有记录
  Future<bool> hasTransactionByPill(int pillId) async {
    final result =
        await (select(transactions)
              ..where((tbl) => tbl.pillId.equals(pillId))
              ..limit(1))
            .getSingleOrNull();
    return result != null;
  }

  Future<List<Transaction>> getQuantitiesTransactions(
    DateTime start,
    DateTime end,
  ) async {
    final allTransactions =
        await (select(transactions)..where(
          (tbl) =>
              tbl.isCustom.equals(false) &
              tbl.calcQty.isNotValue('0') &
              tbl.startTime.isBetweenValues(
                start.toUtc(),
                end.toUtc().subtract(const Duration(seconds: 1)),
              ),
        )).get();
    List<Transaction> result = [];
    for (var item in allTransactions) {
      final qtys =
          await (select(quantities)
            ..where((tbl) => tbl.transactionId.equals(item.id))).get();
      if (qtys.isEmpty) continue;
      result.add(
        item.copyWith(
          startTime: item.startTime.toLocal(),
          endTime: Value(item.endTime?.toLocal()),
        ),
      );
    }
    return result;
  }

  Future<List<TransactionModel>> getTransactions(
    DateTime startDate,
    DateTime endDate,
    Map<int, int> map, {
    int? planId,
  }) async {
    final lower =
        startDate
            .copyWith(
              hour: 0,
              minute: 0,
              second: 0,
              millisecond: 0,
              microsecond: 0,
            )
            .toUtc();
    final higher =
        endDate
            .copyWith(
              hour: 23,
              minute: 59,
              second: 59,
              millisecond: 999,
              microsecond: 999,
            )
            .toUtc();
    final records =
        await (select(transactions)
          ..where((tbl) => tbl.startTime.isBetweenValues(lower, higher))).get();
    final allTransactions =
        planId == null ? records : records.where((e) => e.planId == planId);

    final List<TransactionModel> result = [];
    for (var item in allTransactions) {
      final list = await getAllQuantities(item.id);
      result.add(TransactionModel.fromTransaction(item, list));
    }
    return result;
  }

  Future<List<TransactionModel>> getTransactionHistoryByPill(int pillId) async {
    final allTransactions =
        await (select(transactions)
          ..where((tbl) => tbl.pillId.equals(pillId))).get();
    final List<TransactionModel> result = [];
    for (var item in allTransactions) {
      // 自动减少的记录不显示
      if (!item.isCustom && item.isNegative) continue;
      final list = await getAllQuantities(item.id);
      if (list.isEmpty) continue;
      result.add(TransactionModel.fromTransaction(item, list));
    }
    return result;
  }

  Future<void> deleteTransactionFromPlan(int planId, DateTime date) async {
    final lower = DateTime(date.year, date.month, date.day).toUtc();
    final higher = lower
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    await (delete(transactions)..where(
      (tbl) =>
          tbl.planId.equals(planId) &
          tbl.startTime.isBetweenValues(lower, higher),
    )).go();
  }

  Future<Transaction?> getLastTransactionByPlan(int planId) async {
    return (select(transactions)
          ..where((tbl) => tbl.planId.equals(planId))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.startTime,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1))
        .getSingleOrNull();
  }
}
