import 'package:drift/drift.dart';

import '../database/app_database.dart';

class PlanModel {
  int? id;

  // 关联药物
  int pillId;

  // 是否启用
  bool isEnabled;

  // 计划名称
  String name;

  // 计划数量
  int qty;

  // 计划数量单位
  String unit;

  int? numerator; // 计划数量分子

  int? denominator; // 计划数量分母

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
    required this.qty,
    required this.unit,
    this.numerator,
    this.denominator,
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
  }); // 自动生成 UUID 作为 ID

  // 处理频率显示
  String getRepeatText() {
    if (repeatValues.isEmpty) return '';
    if (repeatUnit == 'day') {
      if (repeatValues.length != 1) return '';
      final unit = DateUnit.day.displayName;
      final val = repeatValues[0];
      if (val == 1) return '每$unit';
      return '每${val.toString()}$unit';
    }
    if (repeatUnit == 'week') {
      final weekNames = repeatValues
          .where((element) => element >= 1 && element <= 7)
          .map((e) => weekdays[e - 1])
          .toList()
          .join('、');
      final unit = DateUnit.week.displayName;
      return '每$unit$weekNames';
    }
    if (repeatUnit == 'month') {
      final unit = DateUnit.month.displayName;
      return '每$unit${repeatValues.where((i) => i > 0 && i < 32).join('、')}号';
    }
    if (repeatUnit == 'year') {
      final unit = DateUnit.year.displayName;
      return '每$unit$startDate';
    }
    return '';
  }

  // 处理提醒显示
  String getReminderText() {
    if (reminderValue == null) return '不提醒';
    if (reminderValue == 0) return '计划时间开始时';
    final unit = reminderUnit == 'minute' ? '分钟' : '小时';
    return '提前$reminderValue$unit';
  }

  String getReminderAllText() {
    String str = getReminderText();
    if (reminderValue == null) return str;
    if (reminderMethod == 'clock') str += '，闹钟提醒';
    if (reminderMethod == 'notify') str += '，通知提醒';
    return str;
  }

  // 处理停药条件
  String getCycleText() {
    if (cycles.isEmpty) return '无需停药';
    return cycles.map((c) => c.getCycleText() + c.getNameText()).join('，');
  }

  String getDurationText() {
    if (duration == null || duration == 0) return '';
    final unit = durationUnit == 'minute' ? '分钟' : '小时';
    return '$duration$unit';
  }

  String getRepeatEndText() {
    if (endDate.isEmpty) return '不结束';
    return '截止$endDate';
  }

  String getStatusText() {
    return isEnabled ? '启用' : '停用';
  }

  Plan? toPlan() {
    if (id == null) return null;
    return Plan(
      id: id!,
      pillId: pillId,
      isEnabled: isEnabled,
      name: name,
      qty: qty,
      unit: unit,
      numerator: numerator,
      denominator: denominator,
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
      qty: Value(qty),
      unit: Value(unit),
      numerator: Value(numerator),
      denominator: Value(denominator),
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
      qty: plan.qty,
      unit: plan.unit,
      numerator: plan.numerator,
      denominator: plan.denominator,
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

  String getCycleText() {
    DateUnit? dateUnit = DateUnit.fromString(unit);
    if (dateUnit == null) return '';
    return '$value${dateUnit.displayName}';
  }

  String getNameText() {
    return isStop ? '停药' : '用药';
  }
}

final List<String> weekdays = ['一', '二', '三', '四', '五', '六', '日'];
final int lastDayOfMonth = -1;

// 定义枚举
enum DateUnit {
  day,
  week,
  month,
  year;

  // 获取显示名称
  String get displayName {
    switch (this) {
      case DateUnit.day:
        return '天';
      case DateUnit.week:
        return '周';
      case DateUnit.month:
        return '月';
      case DateUnit.year:
        return '年';
    }
  }

  // 获取字符串值
  @override
  String toString() {
    switch (this) {
      case DateUnit.day:
        return 'day';
      case DateUnit.week:
        return 'week';
      case DateUnit.month:
        return 'month';
      case DateUnit.year:
        return 'year';
    }
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

  // 获取所有枚举值及其显示名称
  static List<Map<String, dynamic>> get options {
    return DateUnit.values
        .map((freq) => {'value': freq, 'label': freq.displayName})
        .toList();
  }
}
