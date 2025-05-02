import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/pill_model.dart';
import '../models/plan_model.dart';
import '../models/transaction_model.dart';

class HiveService {
  static const String _themeBoxName = 'theme_box';
  static const String _seedColorKey = 'seed_color';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PlanModelAdapter());
    Hive.registerAdapter(CycleAdapter());
    Hive.registerAdapter(PillModelAdapter());
    Hive.registerAdapter(SpecAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(QuantityAdapter());
    await Hive.openBox(_themeBoxName);
  }

  Future<void> saveSeedColor(Color color) async {
    final box = Hive.box(_themeBoxName);
    await box.put(_seedColorKey, color.value);
  }

  Future<Color?> getSeedColor() async {
    final box = Hive.box(_themeBoxName);
    final value = box.get(_seedColorKey) as int?;
    return value != null ? Color(value) : null;
  }
}
