import 'package:hive_flutter/hive_flutter.dart';

import '../models/pill_model.dart';
import '../models/transaction_model.dart';

class PillService {
  static const boxName = 'pills_box';

  Future<void> init() async {
    await Hive.openBox<PillModel>(boxName);
  }

  Future<bool> isEmpty() async {
    final box = Hive.box<PillModel>(boxName);
    return box.isEmpty;
  }

  Future<List<PillModel>> getAllPills() async {
    return Hive.box<PillModel>(boxName).values.toList();
  }

  Future<PillModel> firstPill(String id) async {
    return Hive.box<PillModel>(boxName).values.firstWhere((d) => d.id == id);
  }

  Future<void> addPill(PillModel pill) async {
    final i = pill.packSpecs.indexWhere((p) => p.unit == pill.initialUnit);
    // 如果没有找到对应的单位，直接抛出错误
    if (i == -1) throw Exception('初始数量单位应在包装规格列表中');
    final total = pill.initialQty * pill.getTotalQtyMultiple(i);
    pill.qty = total;
    pill.numerator = pill.initialNum;
    pill.denominator = pill.initialDen;
    final box = Hive.box<PillModel>(boxName);
    await box.add(pill);
  }

  Future<void> updatePill(PillModel pill) async {
    await pill.save();
  }

  Future<void> updatePillQty(TransactionModel transaction) async {
    final pill = await firstPill(transaction.pillId);

    // 计算整数部分总和
    int total = transaction.quantities.fold(0, (sum, q) {
      final index = pill.packSpecs.indexWhere((p) => p.unit == q.unit);
      return sum + q.qty * pill.getTotalQtyMultiple(index);
    });

    // 计算分数部分总和
    final (int sumNum, int sumDenom) = _calculateTotalFraction(transaction);

    // 处理分数部分的整数进位
    int fractionInt = sumNum ~/ sumDenom;
    int remainingNum = sumNum % sumDenom;

    // 总整数变化量
    int totalChange = total + fractionInt;
    int sign = transaction.isNegative ? -1 : 1;
    int totalChangeSigned = totalChange * sign;

    // 更新pill的分数部分
    final (int newNum, int newDenom) = _updateFraction(
      pill.numerator ?? 0,
      pill.denominator ?? 1,
      remainingNum * sign,
      sumDenom,
    );

    // 处理分数进位
    int fractionIntFromFraction = newNum ~/ newDenom;
    int remainingNumFinal = newNum % newDenom;

    // 更新pill的qty
    pill.qty += totalChangeSigned + fractionIntFromFraction;

    // 更新分数部分
    if (remainingNumFinal == 0) {
      pill.numerator = null;
      pill.denominator = null;
    } else {
      pill.numerator = remainingNumFinal;
      pill.denominator = newDenom;
    }

    await pill.save();
  }

  (int, int) _calculateTotalFraction(TransactionModel transaction) {
    int sumNum = 0;
    int sumDenom = 1;

    for (var item in transaction.quantities) {
      if (item.numerator == null ||
          item.denominator == null ||
          item.denominator == 0) {
        continue;
      }

      (sumNum, sumDenom) = _addFractions(
        sumNum,
        sumDenom,
        item.numerator!,
        item.denominator!,
      );
    }

    return (sumNum, sumDenom);
  }

  (int, int) _addFractions(int aNum, int aDenom, int bNum, int bDenom) {
    int lcm = (aDenom * bDenom) ~/ _gcd(aDenom, bDenom);
    int newNum = aNum * (lcm ~/ aDenom) + bNum * (lcm ~/ bDenom);
    int newDenom = lcm;
    int gcdValue = _gcd(newNum, newDenom);
    return (newNum ~/ gcdValue, newDenom ~/ gcdValue);
  }

  (int, int) _updateFraction(
    int existingNum,
    int existingDenom,
    int changeNum,
    int changeDenom,
  ) {
    int newNum = existingNum * changeDenom + changeNum * existingDenom;
    int newDenom = existingDenom * changeDenom;
    int gcdValue = _gcd(newNum, newDenom);
    return (newNum ~/ gcdValue, newDenom ~/ gcdValue);
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }
}
