import 'package:flutter/material.dart';

// 定义枚举
enum DateUnit {
  day,
  week,
  month,
  year;

  // 获取显示名称
  String get value {
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

final List<String> weekdays = ['一', '二', '三', '四', '五', '六', '日'];
final int lastDayOfMonth = -1;

String getFormatDate(DateTime date) {
  return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String getFormatTime(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
