import 'package:drift/drift.dart';

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
    return [];
  }

  Future<void> insertQuantities(int transactionId, List<QuantityModel> list) {
    return batch((b) {
      b.insertAll(
        quantities,
        list
            .map(
              (item) => QuantitiesCompanion(
                transactionId: Value(transactionId),
                qty: Value(item.qty),
                unit: Value(item.unit),
                numerator: Value(item.numerator),
                denominator: Value(item.denominator),
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

  Future<int> add1(Insertable<Transaction> entity) {
    return into(transactions).insert(entity);
  }

  Future<bool> update1(Transaction item) {
    return update(transactions).replace(item);
  }

  Future<void> delete1(int id) {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<TransactionModel>> getTodayTransactions(DateTime today) async {
    final todayStart = DateTime(today.year, today.month, today.day);
    final allTransactions =
        await (select(transactions)..where(
          (tbl) => tbl.startTime.isBetweenValues(
            todayStart,
            todayStart
                .add(const Duration(days: 1))
                .subtract(const Duration(seconds: 1)),
          ),
        )).get();
    final List<TransactionModel> result = [];
    for (var item in allTransactions) {
      final list = await getAllQuantities(item.id);
      result.add(TransactionModel.fromTransaction(item, list));
    }
    return result;
  }

  Future<int> addTransaction(TransactionModel transaction) async {
    transaction.timestamp = DateTime.now();
    final id = await add1(transaction.toCompanion());
    await insertQuantities(id, transaction.quantities);
    return id;
  }
}
