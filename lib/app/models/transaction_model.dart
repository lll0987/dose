import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'quantity_model.dart';

// MEMO 各状态组合含义
// isCustom=true, isNegative=false, quantities.isNotEmpty: 用户在数量调整页面手动增加数量
// isCustom=true, isNegative=true, quantities.isNotEmpty: 用户在数量调整页面手动减少数量
// isCustom=true, isNegative=true, quantities.isEmpty: 用户在忽略日期页面添加忽略日期
// isCustom=false, isNegative=true, quantities.isNotEmpty: 用户在首页/月视图页面点击用药按钮
// isCustom=false, isNegative=true, quantities.isEmpty: 用户在首页/月视图页面点击忽略按钮
// isCustom=false, isNegative=true, quantities.first=0: 系统自动添加的补服记录

class TransactionModel {
  int? id;

  List<QuantityModel> quantities;

  String calcQty;

  bool isNegative; // 是否减少数量

  int pillId;

  int? planId;

  int? revisionId;

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
    this.revisionId,
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
      revisionId: revisionId,
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
      revisionId: Value(revisionId),
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
      revisionId: transaction.revisionId,
      timestamp: transaction.timestamp.toLocal(),
      remark: transaction.remark,
      startTime: transaction.startTime.toLocal(),
      endTime: transaction.endTime?.toLocal(),
    );
  }
}
