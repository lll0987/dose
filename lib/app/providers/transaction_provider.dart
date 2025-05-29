import 'package:flutter/material.dart';

import '../database/repository/transaction_repository.dart';
import '../models/transaction_model.dart';
import 'datetime_provider.dart';
import 'pill_provider.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository;
  final PillProvider _pillProvider;
  final DatetimeProvider _datetimeProvider;

  TransactionProvider(
    this._transactionRepository,
    this._pillProvider,
    this._datetimeProvider,
  ) {
    // 监听时间提供者的变化
    _datetimeProvider.addListener(() {
      // 当日期改变时，重新加载数据
      loadTransactions();
    });
  }

  List<TransactionModel> _todayTransactions = [];

  List<TransactionModel> get todayTransactions => _todayTransactions;

  List<TransactionModel> _missedTransactions = [];

  List<TransactionModel> get missedTransactions => _missedTransactions;

  Future<void> loadTransactions() async {
    _todayTransactions = await _transactionRepository.getDayTransactions(
      _datetimeProvider.today,
    );
    _missedTransactions = await _transactionRepository.getDayTransactions(
      _datetimeProvider.yesterday,
    );
    notifyListeners();
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

  Map<int, Map<int, List<int>>> _yearTransactions = {};

  Map<int, Map<int, List<int>>> get yearTransactions => _yearTransactions;

  Future<void> loadYearTransactions(int year) async {
    _yearTransactions = await _transactionRepository.getYearTransactions(year);
    notifyListeners();
  }
}
