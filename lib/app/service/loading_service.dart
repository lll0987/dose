import 'package:flutter/material.dart';

class LoadingService {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void show() {
    isLoading.value = true;
  }

  void hide() {
    isLoading.value = false;
  }
}

// 全局单例
final loadingService = LoadingService();
