import 'package:flutter/material.dart';

import '../database/repository/pill_repository.dart';
import '../models/pill_model.dart';
import '../models/quantity_model.dart';
import '../utils/result.dart';
import 'plan_provider.dart';

class PillProvider with ChangeNotifier {
  final PillRepository _pillRepository;
  final PlanProvider _planProvider;

  PillProvider(this._pillRepository, this._planProvider) {
    _planProvider.addListener(() {
      notifyListeners();
    });
  }

  List<PillModel> _allPills = [];

  List<PillModel> get allPills => _allPills;

  Future<void> loadPills() async {
    _allPills = await _pillRepository.getAllPills();
    notifyListeners();
  }

  Map<int, PillModel> get pillMap => {
    for (var pill in _allPills) pill.id!: pill,
  };

  Map<int, int> get pillPlanCount {
    final Map<int, int> result = {};
    for (var pill in _allPills) {
      final plans = _planProvider.groupedPlans[pill.id];
      if (plans == null || plans.isEmpty) {
        result[pill.id!] = -1;
        continue;
      }
      final quantity =
          QuantityModel.sum(plans.map((e) => e.quantity).toList())!;
      final count = (pill.quantity ~/ quantity) * plans.length;
      result[pill.id!] = count;
    }
    return result;
  }

  Future<Result<int>> addPill(PillModel pill) async {
    final result = await _pillRepository.addPill(pill);
    if (result.isSuccess) {
      await loadPills();
    }
    return result;
  }

  Future<void> updatePill(PillModel pill) async {
    await _pillRepository.updatePill(pill);
    await loadPills();
  }

  Future<Result<void>> deletePill(int id) async {
    final result = await _pillRepository.deletePill(id);
    if (result.isSuccess) {
      await loadPills();
    }
    return result;
  }
}
