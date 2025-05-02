import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../models/plan_model.dart';
import '../services/plan_service.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService;

  PlanProvider(this._planService);

  List<PlanModel> _allPlans = [];

  List<PlanModel> get allPlans => _allPlans;

  Future<void> loadPlans() async {
    _allPlans = await _planService.getAllPlans();
    notifyListeners();
  }

  // 获取按 pillId 分组后的计划数据
  Map<String, List<PlanModel>> get groupedPlans {
    return groupBy(_allPlans, (plan) => plan.pillId);
  }

  Future<void> addPlan(PlanModel plan) async {
    await _planService.addPlan(plan);
    await loadPlans(); // 重新加载数据
  }

  Future<void> updatePlan(PlanModel plan) async {
    await _planService.updatePlan(plan);
    await loadPlans();
  }

  Future<void> deletePlan(String id) async {
    await _planService.deletePlan(id);
    await loadPlans();
  }
}
