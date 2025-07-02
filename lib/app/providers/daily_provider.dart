import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/repository/transaction_repository.dart';
import '../models/plan_model.dart';
import '../models/transaction_model.dart';
import '../utils/datetime.dart';
import 'pill_provider.dart';
import 'plan_provider.dart';

class DailyProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository;
  final PlanProvider _planProvider;
  final PillProvider _pillProvider;

  DailyProvider(
    this._transactionRepository,
    this._planProvider,
    this._pillProvider,
  ) {
    _scheduleMidnightRefresh(); // 设置一次性的定时器到明天零点

    // 监听 plan 的变化，用于通知 daily 的监听者（如 UI）
    _planProvider.addListener(() {
      notifyListeners(); // 转发通知
    });

    _pillProvider.addListener(() {
      notifyListeners();
    });
  }

  Future<void> loadTransactions() async {
    await loadDailyTransactions();
    await loadMonthTransactions();
    await loadYearTransactions();
    notifyListeners();
  }

  Future<void> loadDailyData() async {
    await loadDailyTransactions();
    notifyListeners();
  }

  Future<void> loadHistoryData({required int year, int? month}) async {
    _year = year;
    if (month != null) _month = month;
    await loadMonthTransactions();
    await loadYearTransactions();
    notifyListeners();
  }

  Timer? _timer;
  DateTime _today = _getToday();

  DateTime get today => _today;
  DateTime get yesterday => _today.subtract(const Duration(days: 1));
  DateTime get _todayEnd =>
      _today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));

  List<PlanModel> get dailyPlans =>
      _getDailyPlans(_planProvider.allPlans, _today);
  List<PlanModel> get missedPlans =>
      _getDailyPlans(_planProvider.allPlans, yesterday);

  List<TransactionModel> _dailyTransactions = [];
  Future<void> loadDailyTransactions() async {
    _dailyTransactions = await _transactionRepository.getTransactions(
      yesterday,
      _today.add(const Duration(days: 1)),
    );
  }

  List<PlanItem> get dailyItems {
    return dailyPlans.map((plan) {
      final transactions = getDayTransactions(
        plan.id!,
        _today,
        _dailyTransactions,
      );
      final status = getPlanStatus(
        plan: plan,
        now: _today,
        today: _todayEnd,
        transactions: transactions,
      );
      return PlanItem(
        plan: plan,
        status: status,
        transaction: transactions.firstOrNull,
      );
    }).toList();
  }

  List<PlanItem> get missedItems {
    List<PlanItem> result = [];
    for (var plan in missedPlans) {
      final transactions = getDayTransactions(
        plan.id!,
        yesterday,
        _dailyTransactions,
      );
      final status = getPlanStatus(
        plan: plan,
        now: yesterday,
        today: _todayEnd,
        transactions: transactions,
        planList: dailyPlans,
        allTransactions: _dailyTransactions,
      );
      if (status == PlanStatus.missed) {
        result.add(
          PlanItem(
            plan: plan,
            status: status,
            transaction: transactions.firstOrNull,
          ),
        );
      }
    }
    return result;
  }

  void refreshToday() {
    final newToday = _getToday();
    if (newToday != _today) {
      _today = newToday;
      loadDailyData(); // 刷新 UI
    }
    _scheduleMidnightRefresh(); // 重新设置下一天的定时器
  }

  void _scheduleMidnightRefresh() {
    _timer?.cancel(); // 清除之前的定时器
    final now = DateTime.now();
    final tomorrow = now
        .add(const Duration(days: 1))
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    final durationUntilTomorrow = tomorrow.difference(now);
    _timer = Timer(durationUntilTomorrow, refreshToday);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _month = 1;
  int get month => _month;

  int get _monthDayCount => DateTime(_year, _month + 1, 0).day;
  Map<int, List<PlanModel>> get _monthPlans {
    Map<int, List<PlanModel>> result = {
      0: _getDailyPlans(_planProvider.allPlans, DateTime(_year, _month + 1, 1)),
    };
    for (var i = 1; i <= _monthDayCount; i++) {
      final day = DateTime(_year, _month, i);
      result[i] = _getDailyPlans(_planProvider.allPlans, day);
    }
    return result;
  }

  List<TransactionModel> _monthTransactions = [];
  Future<void> loadMonthTransactions() async {
    final start = DateTime(_year, _month, 1);
    final end = DateTime(_year, _month + 1, 2);
    _monthTransactions =
        (await _transactionRepository.getTransactions(
          start,
          end,
        )).where((t) => t.planId != null).toList();
  }

  Map<int, List<PlanItem>> get monthItems {
    Map<int, List<PlanItem>> result = {};
    for (var entry in _monthPlans.entries) {
      final day = entry.key;
      final plans = entry.value;
      final datetime = DateTime(_year, _month, day);
      result.putIfAbsent(day, () => []);
      result[day]!.addAll(
        plans.map((plan) {
          final transactions = getDayTransactions(
            plan.id!,
            datetime,
            _monthTransactions,
          );
          final key = day == _monthDayCount ? 0 : day + 1;
          final status = getPlanStatus(
            plan: plan,
            now: datetime,
            today: _todayEnd,
            transactions: transactions,
            planList: _monthPlans[key],
            allTransactions: _monthTransactions,
          );
          return PlanItem(
            plan: plan,
            status: status,
            transaction: transactions.firstOrNull,
          );
        }),
      );
    }
    return result;
  }

  int _year = 2025;
  int get year => _year;

  List<Transaction> _yearTransactions = [];
  Future<void> loadYearTransactions() async {
    _yearTransactions = await _transactionRepository.getYearTransactions(_year);
  }

  Map<int, Map<int, List<int>>> get yearTransactions {
    Map<int, Map<int, List<int>>> result = {};
    for (var item in _yearTransactions) {
      final month = item.startTime.month;
      final day = item.startTime.day;
      final value = _pillProvider.pillMap[item.pillId]!.themeValue ?? -1;

      // 如果没有这个月份，创建一个新的子 map
      result.putIfAbsent(month, () => {});

      // 获取当前月份下的日期 map
      var dayMap = result[month]!;

      // 将 pillData 添加到对应日期的列表中
      dayMap.putIfAbsent(day, () => []).add(value);
    }
    return result;
  }
}

class PlanItem {
  PlanModel plan;
  PlanStatus status;
  TransactionModel? transaction;

  String? get startTime =>
      transaction == null
          ? null
          : getFormatTime(TimeOfDay.fromDateTime(transaction!.startTime));
  String? get endTime =>
      transaction == null || transaction!.endTime == null
          ? null
          : getFormatTime(TimeOfDay.fromDateTime(transaction!.endTime!));

  PlanItem({required this.plan, required this.status, this.transaction});
}

DateTime _getToday() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

// 将 HH:mm 转换为总分钟数，便于比较
int _toMinutes(String time) {
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return hour * 60 + minute;
}

// 获取指定日期的计划列表，按开始时间排序
List<PlanModel> _getDailyPlans(List<PlanModel> allPlans, DateTime now) {
  return allPlans.where((plan) => plan.isActive(now)).sorted((a, b) {
    final aMin = _toMinutes(a.startTime);
    final bMin = _toMinutes(b.startTime);
    return aMin.compareTo(bMin); // 升序排列
    // 若需要降序，则改为 bMin.compareTo(aMin)
  }).toList();
}

List<TransactionModel> getDayTransactions(
  int planId,
  DateTime now,
  List<TransactionModel> allTransactions,
) {
  return allTransactions
      .where(
        (t) =>
            t.planId == planId &&
            (!t.startTime.isBefore(now)) &&
            t.startTime.isBefore(now.add(const Duration(days: 1))),
      )
      .toList();
}

// 计划状态
PlanStatus getPlanStatus({
  required PlanModel plan,
  required DateTime now,
  required DateTime today,
  required List<TransactionModel> transactions,
  List<PlanModel>? planList,
  List<TransactionModel>? allTransactions,
}) {
  if (today.isBefore(now)) {
    return PlanStatus.scheduled;
  }
  if (transactions.any((t) => t.quantities.isNotEmpty)) {
    return PlanStatus.taken;
  }
  if (transactions.isNotEmpty) {
    return PlanStatus.ignored;
  }
  if (planList == null || allTransactions == null) {
    return PlanStatus.missed;
  }

  final equalsPlan = plan.equalsPlan(planList);
  if (equalsPlan == null) return PlanStatus.missed;

  final transactionList = getDayTransactions(
    equalsPlan.id!,
    now.add(const Duration(days: 1)),
    allTransactions,
  );
  final transaction = transactionList.firstWhereOrNull(
    (m) => m.quantities.length > 1,
  );
  if (transaction == null) return PlanStatus.missed;

  return PlanStatus.supplemented;
}
