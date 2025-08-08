import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('zh'); // 默认语言

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  static const String languageKey = 'language';

  // 初始化语言（从 SharedPreferences 读取）
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(languageKey);

    _locale = Locale(languageCode ?? 'zh');
    notifyListeners();

    if (languageCode == null) {
      prefs.setString(languageKey, _locale.languageCode);
    }
  }

  // 切换语言
  Future<void> changeLanguage(Locale newLocale) async {
    if (_locale == newLocale) return;

    _locale = newLocale;
    notifyListeners();

    // 持久化
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, newLocale.languageCode);
  }
}
