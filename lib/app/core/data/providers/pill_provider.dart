import 'package:flutter/material.dart';

import '../models/pill_model.dart';
import '../models/transaction_model.dart';
import '../services/pill_service.dart';

class PillProvider with ChangeNotifier {
  final PillService _pillService;

  PillProvider(this._pillService);

  List<PillModel> _allPills = [];

  List<PillModel> get allPills => _allPills;

  Future<void> loadPills() async {
    _allPills = await _pillService.getAllPills();
    notifyListeners();
  }

  Map<String, PillModel> get pillMap {
    final Map<String, PillModel> result = {};
    for (var pill in _allPills) {
      result[pill.id] = pill;
    }
    return result;
  }

  Future<void> addPill(PillModel pill) async {
    await _pillService.addPill(pill);
    await loadPills();
  }

  Future<void> updatePill(PillModel pill) async {
    await _pillService.updatePill(pill);
    await loadPills();
  }

  Future<void> updatePillQty(TransactionModel transaction) async {
    await _pillService.updatePillQty(transaction);
    await loadPills();
  }
}
