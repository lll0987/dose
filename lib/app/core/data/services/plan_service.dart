import 'package:hive_flutter/hive_flutter.dart';

import '../models/plan_model.dart';

class PlanService {
  static const boxName = 'plans_box';

  Future<void> init() async {
    await Hive.openBox<PlanModel>(boxName);
  }

  Future<List<PlanModel>> getAllPlans() async {
    return Hive.box<PlanModel>(boxName).values.toList();
  }

  Future<void> addPlan(PlanModel plan) async {
    final box = Hive.box<PlanModel>(boxName);
    await box.add(plan);
  }

  Future<void> updatePlan(PlanModel plan) async {
    await plan.save();
  }

  Future<void> deletePlan(String id) async {
    final box = Hive.box<PlanModel>(boxName);
    await box.delete(id);
  }
}
