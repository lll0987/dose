import 'dart:async';

import 'package:flutter/material.dart';

class DatetimeProvider extends ChangeNotifier {
  DateTime _today = _getToday();

  Timer? _timer;

  DateTime get today => _today;

  DateTime get yesterday => _today.subtract(const Duration(days: 1));

  DatetimeProvider() {
    _scheduleMidnightRefresh(); // 设置一次性的定时器到明天零点
  }

  void refreshToday() {
    final newToday = _getToday();
    if (newToday != _today) {
      _today = newToday;
      notifyListeners(); // 刷新 UI
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
}

DateTime _getToday() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
