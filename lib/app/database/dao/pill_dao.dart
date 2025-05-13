import 'package:drift/drift.dart';

import '../../models/pill_model.dart';
import '../../models/transaction_model.dart';
import '../app_database.dart';
import '../tables/pills.dart';
import '../tables/specs.dart';

part 'pill_dao.g.dart';

@DriftAccessor(tables: [Pills, Specs])
class PillDao extends DatabaseAccessor<AppDatabase> with _$PillDaoMixin {
  PillDao(super.db);

  Future<bool> isEmpty() async {
    final res = await db.select(pills).getSingleOrNull();
    return res == null;
  }

  Future<List<SpecModel>> getAllSpecs(int pillId) async {
    final specList =
        await (select(specs)
              ..where((tbl) => tbl.pillId.equals(pillId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
    return specList.map((s) => SpecModel(qty: s.qty, unit: s.unit)).toList();
  }

  Future<void> insertSpecs(int pillId, List<SpecModel> packSpecs) {
    return batch((b) {
      b.insertAll(
        specs,
        packSpecs.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return SpecsCompanion(
            pillId: Value(pillId),
            orderIndex: Value(index),
            qty: Value(item.qty),
            unit: Value(item.unit),
          );
        }).toList(),
      );
    });
  }

  Future<void> deleteSpecs(int pillId) {
    return (delete(specs)..where((tbl) => tbl.pillId.equals(pillId))).go();
  }

  Future<List<Pill>> all() {
    return select(pills).get();
  }

  Future<int> add1(Insertable<Pill> entity) {
    return into(pills).insert(entity);
  }

  Future<bool> update1(Pill item) {
    return update(pills).replace(item);
  }

  Future<void> delete1(int id) {
    return (delete(pills)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<PillModel>> getAllPills() async {
    final allPills = await all();
    final List<PillModel> result = [];
    for (var pill in allPills) {
      final specList = await getAllSpecs(pill.id);
      result.add(PillModel.fromPill(pill, specList));
    }
    return result;
  }

  Future<PillModel> firstPill(int id) async {
    final pill =
        await (select(pills)..where((tbl) => tbl.id.equals(id))).getSingle();
    final specList = await getAllSpecs(pill.id);
    return PillModel.fromPill(pill, specList);
  }

  Future<int> addPill(PillModel pill) async {
    final id = await add1(pill.toCompanion());
    await insertSpecs(id, pill.packSpecs);
    return id;
  }

  Future<bool> updatePill(PillModel pill) async {
    if (pill.id == null) return false;
    final r = await update1(pill.toPill()!);
    if (r == false) return false;
    await deleteSpecs(pill.id!);
    await insertSpecs(pill.id!, pill.packSpecs);
    return true;
  }

  Future<void> deletePill(int id) async {
    await delete1(id);
  }

  Future<bool> updatePillQty(TransactionModel transaction) async {
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

    return await update1(pill.toPill()!);
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
