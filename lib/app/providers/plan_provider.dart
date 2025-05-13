import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../database/repository/plan_repository.dart';
import '../models/plan_model.dart';

class PlanProvider with ChangeNotifier {
  final PlanRepository _planRepository;

  PlanProvider(this._planRepository);

  List<PlanModel> _allPlans = [];

  List<PlanModel> get allPlans => _allPlans;

  Future<void> loadPlans() async {
    _allPlans = await _planRepository.getAllPlans();
    notifyListeners();
  }

  // 获取按 pillId 分组后的计划数据
  Map<int, List<PlanModel>> get groupedPlans {
    return groupBy(_allPlans, (plan) => plan.pillId);
  }

  Future<void> addPlan(PlanModel plan) async {
    await _planRepository.addPlan(plan);
    await loadPlans(); // 重新加载数据
  }

  Future<void> updatePlan(PlanModel plan) async {
    await _planRepository.updatePlan(plan);
    await loadPlans();
  }

  Future<void> deletePlan(int id) async {
    await _planRepository.deletePlan(id);
    await loadPlans();
  }
}
