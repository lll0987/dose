import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../database/repository/plan_repository.dart';
import '../models/plan_model.dart';
import '../utils/result.dart';

class PlanProvider with ChangeNotifier {
  final PlanRepository _planRepository;

  PlanProvider(this._planRepository);

  List<PlanModel> _allPlans = [];

  List<PlanModel> get allPlans => _allPlans;

  Map<int, PlanModel> get planMap => {
    for (var plan in _allPlans) plan.id!: plan,
  };

  List<PlanModel> _allRevisionPlans = [];

  List<PlanModel> get allRevisionPlans => _allRevisionPlans;

  Future<void> loadPlans() async {
    _allPlans = await _planRepository.getAllPlans();
    _allRevisionPlans = await _planRepository.getAllRevisionPlans();
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

  Future<void> updatePlan(PlanModel plan, bool isNew) async {
    await _planRepository.updatePlan(plan, isNew);
    await loadPlans();
  }

  Future<Result<void>> deletePlan(int id) async {
    final result = await _planRepository.deletePlan(id);
    if (result.isSuccess) {
      await loadPlans();
    }
    return result;
  }

  Future<void> disablePlan(int id) async {
    await _planRepository.disablePlan(id);
    await loadPlans();
  }

  Future<void> enablePlan(int id) async {
    await _planRepository.enablePlan(id);
    await loadPlans();
  }
}
