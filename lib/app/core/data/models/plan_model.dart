import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';

part 'plan_model.g.dart'; // 自动生成的适配器文件

@HiveType(typeId: 1)
class PlanModel extends HiveObject {
  @HiveField(0)
  String id;

  // 关联药物
  @HiveField(1)
  String pillId;

  // 是否启用
  @HiveField(2)
  bool isEnabled;

  // 计划名称
  @HiveField(3)
  String name;

  // 计划数量
  @HiveField(4)
  int qty;

  // 计划数量单位
  @HiveField(5)
  String unit;

  @HiveField(18)
  int? numerator; // 计划数量分子

  @HiveField(19)
  int? denominator; // 计划数量分母

  // 开始日期
  @HiveField(6)
  String startDate; // "YYYY-MM-DD"

  // 结束日期
  @HiveField(7)
  String endDate; // "YYYY-MM-DD"

  // 是否记录精确时间
  @HiveField(8)
  bool isExactTime;

  // 开始时间
  @HiveField(9)
  String startTime; // "HH:mm"

  // 持续时间单位
  @HiveField(10)
  String? durationUnit; // "minute" | "hour"

  // 持续时间
  @HiveField(11)
  int? duration;

  // 重复设置数值
  @HiveField(12)
  List<int> repeatValues;

  // 重复设置单位
  @HiveField(13)
  String repeatUnit; // "day" | "week" | "month" | "year"

  // 提醒设置数值
  @HiveField(14)
  int? reminderValue;

  // 提醒设置单位
  @HiveField(15)
  String? reminderUnit; // "minute" | "hour"

  // 提醒方式
  @HiveField(16)
  String? reminderMethod; // "clock" | "notify"

  // 周期设置
  @HiveField(17)
  List<Cycle> cycles;

  PlanModel({
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
  }) : id = const Uuid().v4(); // 自动生成 UUID 作为 ID

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
}

// 嵌套周期模型
@HiveType(typeId: 2)
class Cycle extends HiveObject {
  // 周期数值
  @HiveField(0)
  int value;

  // 周期单位
  @HiveField(1)
  String unit; // "day" | "week" | "month" | "year"

  // 是否停药
  @HiveField(2)
  bool isStop;

  Cycle({required this.value, required this.unit, required this.isStop});

  String getCycleText() {
    DateUnit? dateUnit = DateUnit.fromString(unit);
    if (dateUnit == null) return '';
    return '$value${dateUnit.displayName}';
  }

  String getNameText() {
    return isStop ? '停药' : '用药';
  }
}
