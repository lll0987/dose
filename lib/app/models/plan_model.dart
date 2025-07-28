import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../utils/datetime.dart';
import 'quantity_model.dart';

enum PlanStatus {
  taken,
  ignored,
  supplemented,
  missed,
  scheduled,
  none;

  static PlanStatus? fromString(String name) {
    return PlanStatus.values.firstWhereOrNull((e) => e.name == name);
  }
}

class PlanModel {
  int? id;

  // 关联药物
  int pillId;

  // 是否启用
  bool isEnabled;

  DateTime? updateTime;

  // 计划名称
  String name;

  // // 计划数量
  // int qty;
  // // 计划数量单位
  // String unit;
  // int? numerator; // 计划数量分子
  // int? denominator; // 计划数量分母

  QuantityModel quantity; // 计划数量

  // 开始日期
  String startDate; // "YYYY-MM-DD"

  // 结束日期
  String endDate; // "YYYY-MM-DD"

  // 是否记录精确时间
  bool isExactTime;

  // 开始时间
  String startTime; // "HH:mm"

  // 持续时间单位
  String? durationUnit; // "minute" | "hour"

  // 持续时间
  int? duration;

  // 重复设置数值
  List<int> repeatValues;

  // 重复设置单位
  String repeatUnit; // "day" | "week" | "month" | "year"

  // 提醒设置数值
  int? reminderValue;

  // 提醒设置单位
  String? reminderUnit; // "minute" | "hour"

  // 提醒方式
  String? reminderMethod; // "clock" | "notify"

  // 周期设置
  List<CycleModel> cycles;

  int? revisionId;

  PlanModel({
    this.id,
    this.revisionId,
    required this.pillId,
    this.isEnabled = true,
    this.updateTime,
    required this.name,
    required this.quantity,
    required this.startDate,
    required this.endDate,
    required this.repeatValues,
    required this.repeatUnit,
    required this.startTime,
    this.isExactTime = false,
    this.duration,
    this.durationUnit,
    this.reminderValue,
    this.reminderUnit,
    this.reminderMethod,
    required this.cycles,
  });

  bool _isStop(int totalDay) {
    if (cycles.isEmpty) return false;
    final days =
        cycles.map((cycle) {
          if (cycle.unit == DateUnit.day.name) return cycle.value;
          if (cycle.unit == DateUnit.week.name) return cycle.value * 7;
          if (cycle.unit == DateUnit.month.name) return cycle.value * 30;
          if (cycle.unit == DateUnit.year.name) return cycle.value * 365;
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

  // 当日需要执行的计划
  bool isActive(DateTime now) {
    if (isEnabled == false &&
        (updateTime == null ? true : now.isAfter(updateTime!))) {
      return false;
    }
    if (repeatValues.isEmpty) return false;
    if (DateTime.parse(startDate).isAfter(now)) return false;
    if (endDate.isNotEmpty) {
      final end = DateTime.parse(
        endDate,
      ).add(Duration(hours: 23, minutes: 59, seconds: 59));
      if (now.isAfter(end)) return false;
    }

    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime.parse(startDate);
    final totalDay = today.difference(start).inDays;

    final isStop = _isStop(totalDay);
    if (isStop) return false;

    if (repeatUnit == DateUnit.day.name) {
      final val = repeatValues[0];
      if (val < 2) return true;
      return totalDay % val == 0;
    }

    if (repeatUnit == DateUnit.week.name) {
      final currentWeekday = now.weekday; // Monday = 1 ... Sunday = 7
      return repeatValues.contains(currentWeekday);
    }

    if (repeatUnit == DateUnit.month.name) {
      final currentDay = now.day;
      final values = repeatValues;
      if (values[0] == -1) {
        final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
        return currentDay == lastDayOfMonth;
      }
      return values.contains(currentDay);
    }

    if (repeatUnit == DateUnit.year.name) {
      if (repeatValues.length != 2) return false;
      final month = repeatValues[0];
      final day = repeatValues[1];
      return today.month == month && today.day == day;
    }

    return false;
  }

  PlanModel? equalsPlan(List<PlanModel> planList) {
    return planList.firstWhereOrNull(
      (m) => m.pillId == pillId && m.startTime == startTime,
    );
  }

  (DateTime, DateTime?) getTimeRange({
    required DateTime date,
    int? hour,
    int? minute,
  }) {
    if (hour == null || minute == null) {
      (hour, minute) = getTimeFromString(startTime)!;
    }
    final start = DateTime(date.year, date.month, date.day, hour, minute);
    // NEXT 药效时长不仅有小时单位时需要调整结束日期时间计算逻辑
    final end = duration == null ? null : start.add(Duration(hours: duration!));
    return (start, end);
  }

  // 处理频率显示
  String getRepeatText(BuildContext context) {
    if (repeatValues.isEmpty) return '';
    final dateUnit = DateUnit.fromString(repeatUnit);
    if (dateUnit == DateUnit.day) {
      if (repeatValues.length != 1) return '';
      final val = repeatValues[0];
      if (val == 1) return AppLocalizations.of(context)!.repeatRule_every_day;
      return AppLocalizations.of(context)!.repeatRule_day(val);
    }
    if (dateUnit == DateUnit.week) {
      return repeatValues
          .where((element) => element >= 1 && element <= 7)
          .map((e) => getWeekdayDisplayName(context, e))
          .toList()
          .join(', ');
    }
    if (dateUnit == DateUnit.month) {
      return AppLocalizations.of(context)!.repeatRule_month_day(
        repeatValues.where((i) => i > 0 && i < 32).join(', '),
      );
    }
    if (repeatUnit == 'year') {
      if (repeatValues.length != 2) return '';
      final date = DateTime.now().copyWith(
        month: repeatValues[0],
        day: repeatValues[1],
      );
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.MMMd(locale).format(date);
    }
    return '';
  }

  // 处理提醒显示
  String getReminderText(BuildContext context) {
    if (reminderValue == null) {
      return AppLocalizations.of(context)!.reminderOption_none;
    }
    if (reminderValue == 0) {
      return AppLocalizations.of(context)!.reminderOption_start;
    }
    final unit =
        reminderUnit == 'hour'
            ? AppLocalizations.of(context)!.hour
            : AppLocalizations.of(context)!.minute;
    return AppLocalizations.of(context)!.reminderRule('$reminderValue$unit');
  }

  String getReminderAllText(BuildContext context) {
    String str = getReminderText(context);
    if (reminderValue == null) return str;
    if (reminderMethod == 'clock') {
      str += ', ${AppLocalizations.of(context)!.reminderMethod_clock}';
    }
    if (reminderMethod == 'notify') {
      str += ', ${AppLocalizations.of(context)!.reminderMethod_notify}';
    }
    return str;
  }

  // 处理停药条件
  String getCycleText(BuildContext context) {
    if (cycles.isEmpty) {
      return AppLocalizations.of(context)!.noInterruptionNeeded;
    }
    return cycles
        .map((c) => c.getCycleText(context) + c.getNameText(context))
        .join('，');
  }

  String getDurationText(BuildContext context) {
    if (duration == null || duration == 0) return '';
    final unit =
        durationUnit == 'hour'
            ? AppLocalizations.of(context)!.hour
            : AppLocalizations.of(context)!.minute;
    return '$duration$unit';
  }

  String getRepeatStartText(BuildContext context) {
    return AppLocalizations.of(context)!.startOn(startDate);
  }

  String getRepeatEndText(BuildContext context) {
    if (endDate.isEmpty) return '';
    return AppLocalizations.of(context)!.endOn(endDate);
  }

  String getStatusText(BuildContext context) {
    return isEnabled
        ? AppLocalizations.of(context)!.enable
        : AppLocalizations.of(context)!.disable;
  }

  Plan? toPlan() {
    if (id == null) return null;
    return Plan(
      id: id!,
      revisionId: revisionId,
      pillId: pillId,
      isEnabled: isEnabled,
      updateTime: updateTime?.toUtc(),
      name: name,
      qty: quantity.qty,
      unit: quantity.unit!,
      numerator: quantity.fraction.numerator,
      denominator: quantity.fraction.denominator,
      startDate: startDate,
      endDate: endDate,
      repeatValues: repeatValues.join(','),
      repeatUnit: repeatUnit,
      startTime: startTime,
      isExactTime: isExactTime,
      duration: duration,
      durationUnit: durationUnit,
      reminderValue: reminderValue,
      reminderUnit: reminderUnit,
      reminderMethod: reminderMethod,
    );
  }

  PlansCompanion toCompanion() {
    return PlansCompanion(
      revisionId: Value(revisionId),
      pillId: Value(pillId),
      isEnabled: Value(isEnabled),
      updateTime: Value(updateTime?.toUtc()),
      name: Value(name),
      qty: Value(quantity.qty),
      unit: Value(quantity.unit!),
      numerator: Value(quantity.fraction.numerator),
      denominator: Value(quantity.fraction.denominator),
      startDate: Value(startDate),
      endDate: Value(endDate),
      repeatValues: Value(repeatValues.join(',')),
      repeatUnit: Value(repeatUnit),
      startTime: Value(startTime),
      isExactTime: Value(isExactTime),
      duration: Value(duration),
      durationUnit: Value(durationUnit),
      reminderValue: Value(reminderValue),
      reminderUnit: Value(reminderUnit),
      reminderMethod: Value(reminderMethod),
    );
  }

  RevisionsCompanion toRevision({int? planId}) {
    planId ??= id;
    return RevisionsCompanion(
      planId: Value(planId!),
      pillId: Value(pillId),
      name: Value(name),
      qty: Value(quantity.qty),
      unit: Value(quantity.unit!),
      numerator: Value(quantity.fraction.numerator),
      denominator: Value(quantity.fraction.denominator),
      startDate: Value(startDate),
      endDate: Value(endDate),
      repeatValues: Value(repeatValues.join(',')),
      repeatUnit: Value(repeatUnit),
      startTime: Value(startTime),
      isExactTime: Value(isExactTime),
      duration: Value(duration),
      durationUnit: Value(durationUnit),
      reminderValue: Value(reminderValue),
      reminderUnit: Value(reminderUnit),
      reminderMethod: Value(reminderMethod),
    );
  }

  PlanModel copyWith({
    int? id,
    int? revisionId,
    int? pillId,
    bool? isEnabled,
    DateTime? updateTime,
    String? name,
    QuantityModel? quantity,
    String? startDate,
    String? endDate,
    List<int>? repeatValues,
    String? repeatUnit,
    String? startTime,
    bool? isExactTime,
    int? duration,
    String? durationUnit,
    int? reminderValue,
    String? reminderUnit,
    String? reminderMethod,
    List<CycleModel>? cycles,
  }) {
    return PlanModel(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      pillId: pillId ?? this.pillId,
      isEnabled: isEnabled ?? this.isEnabled,
      updateTime: updateTime ?? this.updateTime,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity.copyWith(),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      repeatValues: repeatValues ?? this.repeatValues,
      repeatUnit: repeatUnit ?? this.repeatUnit,
      startTime: startTime ?? this.startTime,
      isExactTime: isExactTime ?? this.isExactTime,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
      reminderValue: reminderValue ?? this.reminderValue,
      reminderUnit: reminderUnit ?? this.reminderUnit,
      reminderMethod: reminderMethod ?? this.reminderMethod,
      cycles: cycles ?? this.cycles,
    );
  }
}

PlanModel fromPlanToModel(Plan plan, List<CycleModel> cycles) {
  return PlanModel(
    id: plan.id,
    revisionId: plan.revisionId,
    pillId: plan.pillId,
    isEnabled: plan.isEnabled,
    updateTime: plan.updateTime?.toLocal(),
    name: plan.name,
    quantity: QuantityModel(
      qty: plan.qty,
      unit: plan.unit,
      fraction: FractionModel(plan.numerator, plan.denominator),
    ),
    startDate: plan.startDate,
    endDate: plan.endDate,
    repeatValues:
        plan.repeatValues.split(',').map((s) => int.parse(s)).toList(),
    repeatUnit: plan.repeatUnit,
    startTime: plan.startTime,
    isExactTime: plan.isExactTime,
    duration: plan.duration,
    durationUnit: plan.durationUnit,
    reminderValue: plan.reminderValue,
    reminderUnit: plan.reminderUnit,
    reminderMethod: plan.reminderMethod,
    cycles: cycles,
  );
}

PlanModel fromRevisionToPlan(
  Revision revision,
  Plan plan,
  List<CycleModel> cycles,
) {
  return PlanModel(
    id: revision.planId,
    revisionId: revision.id,
    pillId: revision.pillId,
    isEnabled: plan.isEnabled,
    updateTime: plan.updateTime?.toLocal(),
    name: revision.name,
    quantity: QuantityModel(
      qty: revision.qty,
      unit: revision.unit,
      fraction: FractionModel(revision.numerator, revision.denominator),
    ),
    startDate: revision.startDate,
    endDate: revision.endDate,
    repeatValues:
        revision.repeatValues.split(',').map((s) => int.parse(s)).toList(),
    repeatUnit: revision.repeatUnit,
    startTime: revision.startTime,
    isExactTime: revision.isExactTime,
    duration: revision.duration,
    durationUnit: revision.durationUnit,
    reminderValue: revision.reminderValue,
    reminderUnit: revision.reminderUnit,
    reminderMethod: revision.reminderMethod,
    cycles: cycles,
  );
}

RevisionsCompanion fromPlanToRevision(Plan plan) {
  return RevisionsCompanion(
    planId: Value(plan.id),
    pillId: Value(plan.pillId),
    name: Value(plan.name),
    qty: Value(plan.qty),
    unit: Value(plan.unit),
    numerator: Value(plan.numerator),
    denominator: Value(plan.denominator),
    startDate: Value(plan.startDate),
    endDate: Value(plan.endDate),
    repeatValues: Value(plan.repeatValues),
    repeatUnit: Value(plan.repeatUnit),
    startTime: Value(plan.startTime),
    isExactTime: Value(plan.isExactTime),
    duration: Value(plan.duration),
    durationUnit: Value(plan.durationUnit),
    reminderValue: Value(plan.reminderValue),
    reminderUnit: Value(plan.reminderUnit),
    reminderMethod: Value(plan.reminderMethod),
  );
}

// 嵌套周期模型
class CycleModel {
  // 周期数值
  int value;

  // 周期单位
  String unit; // "day" | "week" | "month" | "year"

  // 是否停药
  bool isStop;

  CycleModel({required this.value, required this.unit, required this.isStop});

  String getCycleText(BuildContext context) {
    DateUnit? dateUnit = DateUnit.fromString(unit);
    if (dateUnit == null) return '';
    return '$value${dateUnit.displayName(context)}';
  }

  String getNameText(BuildContext context) {
    return isStop
        ? AppLocalizations.of(context)!.withdrawal
        : AppLocalizations.of(context)!.medication;
  }
}

class PlanItemModel {
  int id;
  int pillId;
  String text;
  String startTime;
  int? revisionId;

  PlanItemModel({
    required this.id,
    required this.pillId,
    required this.text,
    required this.startTime,
    this.revisionId,
  });
}

final int lastDayOfMonth = -1;

// 定义枚举
enum DateUnit {
  day,
  week,
  month,
  year;

  // 获取显示名称
  String displayName(BuildContext context) {
    switch (this) {
      case DateUnit.day:
        return AppLocalizations.of(context)!.day;
      case DateUnit.week:
        return AppLocalizations.of(context)!.week;
      case DateUnit.month:
        return AppLocalizations.of(context)!.month;
      case DateUnit.year:
        return AppLocalizations.of(context)!.year;
    }
  }

  // 根据字符串值返回对应的枚举值
  static DateUnit? fromString(String name) {
    return DateUnit.values.firstWhereOrNull((e) => e.name == name);
  }
}

class PlanCacheModel {
  int planId;
  int? revisionId;
  String date;
  String status;
  String? qty;
  DateTime? start;
  DateTime? end;

  PlanCacheModel({
    required this.planId,
    this.revisionId,
    required this.date,
    required this.status,
    this.qty,
    this.start,
    this.end,
  });

  static PlanCacheModel fromPlanStatusCache(PlanStatusCache e) {
    return PlanCacheModel(
      planId: e.planId,
      revisionId: e.revisionId,
      date: e.date,
      status: e.status,
      qty: e.qty,
      start: e.start,
      end: e.end,
    );
  }
}
