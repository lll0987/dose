import 'package:flutter/material.dart';
import 'package:pillo/app/core/data/providers/pill_provider.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService;
  final PillProvider _pillProvider;

  TransactionProvider(this._transactionService, this._pillProvider);

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionService.addTransaction(transaction);
    await _pillProvider.updatePillQty(transaction);
  }
}
