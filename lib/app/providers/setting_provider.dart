import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider with ChangeNotifier {
  static const String datePatternKey = 'datePattern';
  static const List<String> datePatterns = ['E MM/dd', 'EEEE', 'yyyy-M-d'];

  String _datePattern = datePatterns.first;
  String get datePattern => _datePattern;

  void changeDatePattern(String pattern) async {
    if (_datePattern == pattern) return;

    _datePattern = pattern;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(datePatternKey, pattern);
  }

  static const String minCountKey = 'minCount';

  int _minCount = 10;
  int get minCount => _minCount;

  void changeMinCount(int count) async {
    if (_minCount == count) return;

    _minCount = count;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(minCountKey, count);
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final pattern = prefs.getString(datePatternKey);
    final count = prefs.getInt(minCountKey);

    _datePattern = pattern ?? datePatterns.first;
    _minCount = count ?? 10;
    notifyListeners();

    if (pattern == null) {
      prefs.setString(datePatternKey, _datePattern);
    }
    if (count == null) {
      prefs.setInt(minCountKey, _minCount);
    }
  }
}
