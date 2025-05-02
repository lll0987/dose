import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme({required Color seedColor}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      // 配置其他MD3属性（如按钮样式、文本主题）
    );
  }
}
