import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../utils/datetime.dart';
import 'quantity_model.dart';

class PlanModel {
  int? id;

  // 关联药物
  int pillId;

  // 是否启用
  bool isEnabled;

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

  PlanModel({
    this.id,
    required this.pillId,
    this.isEnabled = true,
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
      pillId: pillId,
      isEnabled: isEnabled,
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
      pillId: Value(pillId),
      isEnabled: Value(isEnabled),
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

  static PlanModel fromPlan(Plan plan, List<CycleModel> cycles) {
    return PlanModel(
      id: plan.id,
      pillId: plan.pillId,
      isEnabled: plan.isEnabled,
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

  PlanItemModel({
    required this.id,
    required this.pillId,
    required this.text,
    required this.startTime,
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

  // 获取字符串值
  @override
  String toString() {
    return super.toString().split('.').last;
  }

  // 根据字符串值返回对应的枚举值
  static DateUnit? fromString(String value) {
    switch (value) {
      case 'day':
        return DateUnit.day;
      case 'week':
        return DateUnit.week;
      case 'month':
        return DateUnit.month;
      case 'year':
        return DateUnit.year;
      default:
        return null; // 如果字符串无效，返回 null
    }
  }
}
