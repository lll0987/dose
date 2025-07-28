import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/repository/plan_cache_repository.dart';
import '../database/repository/transaction_repository.dart';
import '../models/plan_model.dart';
import '../utils/datetime.dart';
import 'pill_provider.dart';
import 'plan_provider.dart';

class DailyProvider with ChangeNotifier {
  final PlanCacheRepository _planCacheRepository;
  final TransactionRepository _transactionRepository;
  final PlanProvider _planProvider;
  final PillProvider _pillProvider;

  DailyProvider(
    this._planCacheRepository,
    this._transactionRepository,
    this._planProvider,
    this._pillProvider,
  ) {
    _scheduleMidnightRefresh(); // 设置一次性的定时器到明天零点

    // 监听 plan 的变化，用于通知 daily 的监听者（如 UI）
    _planProvider.addListener(() {
      notifyListeners(); // 转发通知
      loadAllData();
    });

    _pillProvider.addListener(() {
      notifyListeners();
    });
  }

  Future<void> initData() async {
    final now = DateTime.now();
    await loadHistoryData(year: now.year, month: now.month);
    await loadDailyData();
  }

  Future<void> loadAllData() async {
    await loadDailyData();
    await loadMonthData();
    await loadYearTransactions();
  }

  Future<void> loadHistoryData({required int year, int? month}) async {
    _year = year;
    if (month != null) _month = month;
    await loadMonthData();
    await loadYearTransactions();
  }

  Timer? _timer;
  DateTime _today = _getToday();

  DateTime get today => _today;
  DateTime get yesterday => _today.subtract(const Duration(days: 1));

  List<PlanItem> dailyItems = [];
  List<PlanItem> missedItems = [];
  Future<void> loadDailyData() async {
    final caches = await _planCacheRepository.getAllPlanCaches(
      yesterday,
      _today,
    );
    final map = groupBy(caches, (e) => e.date);

    final todayStr = getCacheFormatDate(_today);
    dailyItems =
        map[todayStr]?.where((e) => e.status != PlanStatus.none.name).map((e) {
          return PlanItem(
            plan: _planProvider.planMap[e.planId]!,
            status: PlanStatus.fromString(e.status)!,
          );
        }).toList() ??
        [];

    final yesterdayStr = getCacheFormatDate(yesterday);
    missedItems =
        map[yesterdayStr]?.where((e) => e.status == PlanStatus.missed.name).map(
          (e) {
            return PlanItem(
              plan: _planProvider.planMap[e.planId]!,
              status: PlanStatus.fromString(e.status)!,
            );
          },
        ).toList() ??
        [];

    final missedPlans = missedItems.map((e) => e.plan).toList();
    for (var item in dailyItems) {
      final p = item.plan.equalsPlan(missedPlans);
      if (p != null) item.missedPlan = p;
    }

    final dailyPlans = dailyItems.map((e) => e.plan).toList();
    for (var item in missedItems) {
      final p = item.plan.equalsPlan(dailyPlans);
      if (p != null) item.dailyPlan = p;
    }

    notifyListeners();
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

  Map<int, List<PlanItem>> monthItems = {};
  Future<void> loadMonthData() async {
    final caches = await _planCacheRepository.getAllPlanCaches(
      DateTime(_year, _month, 0),
      DateTime(_year, _month, _monthDayCount),
    );
    final map = groupBy(caches, (e) => e.date);
    final now = DateTime.now();

    monthItems = {};
    for (var i = 0; i <= _monthDayCount; i++) {
      final dayStr = getCacheFormatDate(DateTime(_year, _month, i));
      final isScheduled = DateTime(_year, _month, i).isAfter(now);
      monthItems[i] =
          map[dayStr]
              ?.where((e) => e.status != PlanStatus.none.name)
              .map(
                (e) => PlanItem(
                  plan: _planProvider.planMap[e.planId]!,
                  status:
                      isScheduled
                          ? PlanStatus.scheduled
                          : PlanStatus.fromString(e.status)!,
                ),
              )
              .toList() ??
          [];
    }
    notifyListeners();
  }

  int _year = 2025;
  int get year => _year;

  List<Transaction> _yearTransactions = [];
  Future<void> loadYearTransactions() async {
    _yearTransactions = await _transactionRepository.getYearTransactions(_year);
    notifyListeners();
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
  DateTime? start;
  DateTime? end;
  String? qty;
  PlanModel? missedPlan;
  PlanModel? dailyPlan;

  String? get startTime =>
      start == null ? null : getFormatTime(TimeOfDay.fromDateTime(start!));
  String? get endTime =>
      end == null ? null : getFormatTime(TimeOfDay.fromDateTime(end!));

  PlanItem({
    required this.plan,
    required this.status,
    this.start,
    this.end,
    this.qty,
    this.missedPlan,
    this.dailyPlan,
  });
}

DateTime _getToday() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
