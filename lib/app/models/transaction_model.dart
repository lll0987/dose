import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'quantity_model.dart';

class TransactionModel {
  int? id;

  List<QuantityModel> quantities;

  String calcQty;

  bool isNegative; // 是否减少数量

  int pillId;

  int? planId;

  DateTime? timestamp;

  String? remark;

  bool isCustom;

  DateTime startTime;

  DateTime? endTime;

  TransactionModel({
    this.id,
    required this.quantities,
    this.calcQty = '',
    this.isNegative = true,
    required this.pillId,
    this.planId,
    this.timestamp,
    this.remark,
    this.isCustom = false,
    required this.startTime,
    this.endTime,
  });

  Transaction? toTransaction() {
    if (id == null) return null;
    return Transaction(
      id: id!,
      pillId: pillId,
      planId: planId,
      isCustom: isCustom,
      isNegative: isNegative,
      calcQty: calcQty,
      timestamp: timestamp!.toUtc(),
      remark: remark,
      startTime: startTime.toUtc(),
      endTime: endTime?.toUtc(),
    );
  }

  TransactionsCompanion toCompanion() {
    assert(timestamp != null);
    return TransactionsCompanion(
      pillId: Value(pillId),
      planId: Value(planId),
      isCustom: Value(isCustom),
      isNegative: Value(isNegative),
      calcQty: Value(calcQty),
      timestamp: Value(timestamp!.toUtc()),
      remark: Value(remark),
      startTime: Value(startTime.toUtc()),
      endTime: Value(endTime?.toUtc()),
    );
  }

  static TransactionModel fromTransaction(
    Transaction transaction,
    List<QuantityModel> quantities,
  ) {
    return TransactionModel(
      quantities: quantities,
      calcQty: transaction.calcQty,
      id: transaction.id,
      isCustom: transaction.isCustom,
      isNegative: transaction.isNegative,
      pillId: transaction.pillId,
      planId: transaction.planId,
      timestamp: transaction.timestamp.toLocal(),
      remark: transaction.remark,
      startTime: transaction.startTime.toLocal(),
      endTime: transaction.endTime?.toLocal(),
    );
  }
}
