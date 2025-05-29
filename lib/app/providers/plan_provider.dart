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

  Future<void> loadPlans() async {
    _allPlans = await _planRepository.getAllPlans();
    notifyListeners();
  }

  // 获取按 pillId 分组后的计划数据
  Map<int, List<PlanModel>> get groupedPlans {
    return groupBy(_allPlans, (plan) => plan.pillId);
  }

  bool _isPlanStop(List<CycleModel> cycles, int totalDay) {
    if (cycles.isEmpty) return false;
    final days =
        cycles.map((cycle) {
          if (cycle.unit == DateUnit.day.toString()) return cycle.value;
          if (cycle.unit == DateUnit.week.toString()) return cycle.value * 7;
          if (cycle.unit == DateUnit.month.toString()) return cycle.value * 30;
          if (cycle.unit == DateUnit.year.toString()) return cycle.value * 365;
          return 0;
        }).toList();

    final cycleLength = days.fold(0, (sum, item) => sum + item);
    int offset = totalDay % cycleLength;
    for (int i = 0; i < days.length; i++) {
      final value = days[i];
      if (offset < value) {
        return cycles[i].isStop;
      }
      offset -= value;
    }
    return false;
  }

  List<PlanModel> getEnabledPlans(DateTime now) {
    return _allPlans.where((plan) {
      if (plan.isEnabled == false) return false;
      if (plan.repeatValues.isEmpty) return false;
      if (plan.endDate.isNotEmpty) {
        final endDate = DateTime.parse(plan.endDate).add(Duration(days: 1));
        if (now.isAfter(endDate)) return false;
      }
      return true;
    }).toList();
  }

  bool _isPlanActive(PlanModel plan, DateTime now) {
    final unit = plan.repeatUnit;
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime.parse(plan.startDate);
    final totalDay = today.difference(startDate).inDays;

    final isStop = _isPlanStop(plan.cycles, totalDay);
    if (isStop) return false;

    if (unit == DateUnit.day.toString()) {
      final val = plan.repeatValues[0];
      if (val < 2) return true;
      return totalDay % val == 0;
    }

    if (unit == DateUnit.week.toString()) {
      final currentWeekday = now.weekday; // Monday = 1 ... Sunday = 7
      return plan.repeatValues.contains(currentWeekday);
    }

    if (unit == DateUnit.month.toString()) {
      final currentDay = now.day;
      final values = plan.repeatValues;
      if (values[0] == -1) {
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
        return currentDay == lastDayOfMonth;
      }
      return values.contains(currentDay);
    }

    if (unit == DateUnit.year.toString()) {
      if (plan.repeatValues.length != 2) return false;
      final month = plan.repeatValues[0];
      final day = plan.repeatValues[1];
      return today.month == month && today.day == day;
    }

    return false;
  }

  List<PlanModel> getDailyPlans(DateTime today) {
    return getEnabledPlans(
      today,
    ).where((plan) => _isPlanActive(plan, today)).sorted((a, b) {
      // 将 HH:mm 转换为总分钟数，便于比较
      int toMinutes(String time) {
        final parts = time.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return hour * 60 + minute;
      }

      final aMin = toMinutes(a.startTime);
      final bMin = toMinutes(b.startTime);
      return aMin.compareTo(bMin); // 升序排列
      // 若需要降序，则改为 bMin.compareTo(aMin)
    }).toList();
  }

  Future<void> addPlan(PlanModel plan) async {
    await _planRepository.addPlan(plan);
    await loadPlans(); // 重新加载数据
  }

  Future<void> updatePlan(PlanModel plan) async {
    await _planRepository.updatePlan(plan);
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
