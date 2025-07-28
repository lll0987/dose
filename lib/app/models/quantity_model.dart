import 'package:intl/intl.dart';

import '../database/app_database.dart';

class FractionModel {
  int? numerator;
  int? denominator;

  FractionModel(this.numerator, this.denominator);

  // 简化分数
  void simplify() {
    if (numerator == null || denominator == null) return;
    int gcdVal = _gcd(numerator!, denominator!);
    numerator = numerator! ~/ gcdVal;
    denominator = denominator! ~/ gcdVal;

    // 保证分母为正
    if (denominator! < 0) {
      numerator = -numerator!;
      denominator = -denominator!;
    }
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a.abs();
  }

  bool get isEmpty {
    return numerator == null ||
        denominator == null ||
        numerator == 0 ||
        denominator == 0;
  }

  bool get isNotEmpty => !isEmpty;

  bool operator >(Object other) {
    if (other is! FractionModel) return false;
    final numA = numerator! * denominator!;
    final numB = other.numerator! * other.denominator!;
    return numA > numB;
  }

  @override
  bool operator ==(Object other) {
    if (other is! FractionModel) return false;
    return numerator == other.numerator && denominator == other.denominator;
  }

  @override
  int get hashCode => Object.hash(numerator, denominator);
}

class QuantityModel {
  int qty;
  String? unit;
  FractionModel fraction;
  bool isNegative;

  QuantityModel({
    required this.qty,
    this.unit,
    required this.fraction,
    this.isNegative = false,
  });

  int get _sign => isNegative ? -1 : 1;

  // 将整数和分数合并成一个总分数
  FractionModel get totalFraction {
    int totalNumerator =
        _sign * (qty * (fraction.denominator ?? 1) + (fraction.numerator ?? 0));
    int totalDenominator = fraction.denominator ?? 1;

    // 确保结果是整体分数形式
    return FractionModel(totalNumerator, totalDenominator)..simplify();
  }

  // 加法运算符
  QuantityModel operator +(QuantityModel other) {
    _validateOperation(other);

    // 合并两个分数
    FractionModel thisFrac = totalFraction;
    FractionModel otherFrac = other.totalFraction;

    int newNumerator =
        thisFrac.numerator! * otherFrac.denominator! +
        otherFrac.numerator! * thisFrac.denominator!;
    int newDenominator = thisFrac.denominator! * otherFrac.denominator!;

    return _createFromFraction(newNumerator, newDenominator);
  }

  // 减法运算符
  QuantityModel operator -(QuantityModel other) {
    _validateOperation(other);

    // 合并两个分数
    FractionModel thisFrac = totalFraction;
    FractionModel otherFrac = other.totalFraction;

    int newNumerator =
        thisFrac.numerator! * otherFrac.denominator! -
        otherFrac.numerator! * thisFrac.denominator!;
    int newDenominator = thisFrac.denominator! * otherFrac.denominator!;

    return _createFromFraction(newNumerator, newDenominator);
  }

  /// 整除运算符重载：返回 int 类型
  int operator ~/(QuantityModel other) {
    _validateOperation(other);

    if (isNegative || other.isNegative) return 0;

    // 获取两个数量的总分数形式
    FractionModel thisFrac = totalFraction;
    FractionModel otherFrac = other.totalFraction;

    // 防止除以零
    if (otherFrac.numerator == 0 || otherFrac.denominator == 0) {
      throw Exception('Division by zero is not allowed.');
    }

    // 将分数转为浮点数进行整除
    double thisValue = thisFrac.numerator! / thisFrac.denominator!;
    double otherValue = otherFrac.numerator! / otherFrac.denominator!;

    return (thisValue ~/ otherValue).toInt();
  }

  // 创建新的 QuantityModel 实例
  QuantityModel _createFromFraction(int numerator, int denominator) {
    bool newIsNegative = numerator < 0 || denominator < 0;

    // 简化分数
    FractionModel resultFrac = FractionModel(numerator, denominator);
    resultFrac.simplify();

    // 提取整数和分数部分
    int totalNumerator = (resultFrac.numerator!).abs();
    int totalDenominator = (resultFrac.denominator!).abs();

    int newQty = totalNumerator ~/ totalDenominator;
    int newFractionNumerator = totalNumerator.remainder(totalDenominator);

    return QuantityModel(
      qty: newQty,
      unit: unit,
      fraction: FractionModel(newFractionNumerator, totalDenominator),
      isNegative: newIsNegative,
    );
  }

  // 检查是否可以进行加减运算
  void _validateOperation(QuantityModel other) {
    if (unit != null && other.unit != null && unit != other.unit) {
      throw Exception('Units do not match. Cannot perform operation.');
    }
  }

  static QuantityModel? sum(List<QuantityModel> quantities) {
    if (quantities.isEmpty) return null;
    QuantityModel q = QuantityModel(
      qty: 0,
      fraction: FractionModel(null, null),
    );
    for (var quantity in quantities) {
      q = q + quantity;
    }
    return q;
  }

  String get displayText {
    if (fraction.isEmpty) return qty.abs().toString();
    final num = fraction.numerator!.abs();
    final den = fraction.denominator!.abs();
    return qty == 0 ? '$num/$den' : '${qty.abs()} + $num/$den';
  }

  double get decimalValue {
    final q = qty.abs();
    if (fraction.isEmpty) return q.toDouble();
    final num = fraction.numerator!.abs();
    final den = fraction.denominator!.abs();
    return q + num / den;
  }

  String toFixed({int? decimalPlaces}) {
    if (decimalValue == 0) return '0';

    decimalPlaces ??= 2;

    // 使用 NumberFormat 控制小数位数
    final formatter =
        NumberFormat()
          ..minimumFractionDigits = 0
          ..maximumFractionDigits = decimalPlaces;

    String result = formatter.format(decimalValue);

    // 确保返回正确的格式
    return result.isEmpty ? '0' : result;
  }

  static QuantityModel fromQuantity(Quantity quantity) {
    return QuantityModel(
      qty: quantity.qty,
      unit: quantity.unit,
      fraction: FractionModel(quantity.numerator, quantity.denominator),
    );
  }

  QuantityModel copyWith({
    int? qty,
    String? unit,
    FractionModel? fraction,
    bool? isNegative,
  }) {
    return QuantityModel(
      isNegative: isNegative ?? this.isNegative,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      fraction:
          fraction ??
          FractionModel(this.fraction.numerator, this.fraction.denominator),
    );
  }
}
