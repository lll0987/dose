import 'package:drift/drift.dart';

import '../database/app_database.dart';

class TransactionModel {
  int? id;

  List<QuantityModel> quantities;

  bool isNegative; // 是否减少数量

  int pillId;

  int? planId;

  DateTime timestamp;

  String? remark;

  bool isCustom;

  DateTime startTime;

  DateTime? endTime;

  TransactionModel({
    this.id,
    required this.quantities,
    this.isNegative = true,
    required this.pillId,
    this.planId,
    required this.timestamp,
    this.remark,
    this.isCustom = false,
    required this.startTime,
    this.endTime,
  });

  TransactionsCompanion toCompanion() {
    return TransactionsCompanion(
      pillId: Value(pillId),
      planId: Value(planId),
      isCustom: Value(isCustom),
      isNegative: Value(isNegative),
      timestamp: Value(timestamp),
      remark: Value(remark),
      startTime: Value(startTime),
      endTime: Value(endTime),
    );
  }

  static TransactionModel fromTransaction(
    Transaction transaction,
    List<QuantityModel> quantities,
  ) {
    return TransactionModel(
      quantities: quantities,
      id: transaction.id,
      isCustom: transaction.isCustom,
      isNegative: transaction.isNegative,
      pillId: transaction.pillId,
      planId: transaction.planId,
      timestamp: transaction.timestamp,
      remark: transaction.remark,
      startTime: transaction.startTime,
      endTime: transaction.endTime,
    );
  }
}

class QuantityModel {
  int qty;
  String unit;
  int? numerator;
  int? denominator;

  QuantityModel({
    required this.qty,
    required this.unit,
    this.numerator,
    this.denominator,
  });
}
