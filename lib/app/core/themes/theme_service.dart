import 'package:flutter/material.dart';

import '../data/services/hive_service.dart';

class ThemeService extends ChangeNotifier {
  final HiveService _hiveService;
  Color _seedColor = Colors.lightGreen;

  ThemeService(this._hiveService) {
    _loadTheme();
  }

  Color get seedColor => _seedColor;

  Future<void> _loadTheme() async {
    _seedColor = await _hiveService.getSeedColor() ?? Colors.lightGreen;
    notifyListeners();
  }

  Future<void> updateTheme(Color color) async {
    await _hiveService.saveSeedColor(color);
    _seedColor = color;
    notifyListeners();
  }
}
