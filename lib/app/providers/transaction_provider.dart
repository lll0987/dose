import 'package:flutter/material.dart';

import '../database/repository/transaction_repository.dart';
import '../models/transaction_model.dart';
import 'daily_provider.dart';
import 'pill_provider.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository;
  final PillProvider _pillProvider;
  final DailyProvider _dailyProvider;

  TransactionProvider(
    this._transactionRepository,
    this._pillProvider,
    this._dailyProvider,
  );

  Future<void> loadTransactions() async {
    await _dailyProvider.loadAllData();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionRepository.addTransaction(transaction);
    await loadTransactions();
    await _pillProvider.loadPills();
  }

  Future<void> addTransactions(List<TransactionModel> transactions) async {
    await _transactionRepository.addTransactions(transactions);
    await loadTransactions();
  }

  Future<void> deleteTransactionFromPlan(int planId, DateTime date) async {
    await _transactionRepository.deleteTransactionFromPlan(planId, date);
    await loadTransactions();
  }
}
