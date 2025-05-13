import 'package:flutter/material.dart';

import '../database/repository/transaction_repository.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository;

  TransactionProvider(this._transactionRepository);

  List<TransactionModel> _todayTransactions = [];

  List<TransactionModel> get todayTransactions => _todayTransactions;

  Future<void> loadTransactions(DateTime? today) async {
    today ??= DateTime.now();
    _todayTransactions = await _transactionRepository.getTodayTransactions(
      today,
    );
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionRepository.addTransaction(transaction);
    await loadTransactions(transaction.startTime);
  }
}
