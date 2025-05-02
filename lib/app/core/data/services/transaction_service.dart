import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_model.dart';

class TransactionService {
  static const boxName = 'transactions_box';

  Future<void> init() async {
    await Hive.openBox<TransactionModel>(boxName);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final box = Hive.box<TransactionModel>(boxName);
    transaction.timestamp = DateTime.now();
    await box.add(transaction);
  }

  Future<List<TransactionModel>> getTodayTransactions(DateTime today) async {
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(Duration(days: 1));
    return Hive.box<TransactionModel>(boxName).values.where((tx) {
      return tx.startTime.isAfter(todayStart) &&
          tx.startTime.isBefore(todayEnd);
    }).toList();
  }
}
