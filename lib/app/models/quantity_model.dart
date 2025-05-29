import '../database/app_database.dart';

class FractionModel {
  int? numerator;
  int? denominator;

  FractionModel(this.numerator, this.denominator);

  @override
  bool operator ==(Object other) {
    if (other is FractionModel) {
      return numerator == other.numerator && denominator == other.denominator;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(numerator, denominator);

  bool get isEmpty {
    return numerator == null ||
        denominator == null ||
        numerator == 0 ||
        denominator == 0;
  }

  bool get isNotEmpty => !isEmpty;

  void add(FractionModel fraction) {
    if (isEmpty && fraction.isEmpty) return;
    int num = numerator ?? 0;
    int den = denominator ?? 1;
    int n = fraction.numerator ?? 0;
    int d = fraction.denominator ?? 1;

    numerator = num * d + n * den;
    denominator = den * d;
  }
}

class QuantityModel {
  int qty;
  String? unit;
  FractionModel fraction;

  QuantityModel({required this.qty, this.unit, required this.fraction});

  static QuantityModel fromQuantity(Quantity quantity) {
    return QuantityModel(
      qty: quantity.qty,
      unit: quantity.unit,
      fraction: FractionModel(quantity.numerator, quantity.denominator),
    );
  }

  String get displayText {
    if (fraction.isEmpty) return qty.abs().toString();
    final num = fraction.numerator!.abs();
    final den = fraction.denominator!.abs();
    return qty == 0 ? '$num/$den' : '${qty.abs()} + $num/$den';
  }

  // 转换为分数形式
  FractionModel toFraction() {
    // if (fraction.isEmpty) return fraction;
    int num = fraction.numerator ?? 0;
    int den = fraction.denominator ?? 1;
    return FractionModel(qty * den + num, den);
  }

  static QuantityModel sumQuantities(List<QuantityModel> quantities) {
    final totalFraction = FractionModel(null, null);

    if (quantities.every((e) => e.fraction.isEmpty)) {
      int totalQty = quantities.fold(0, (sum, q) => sum + q.qty);
      return QuantityModel(qty: totalQty, fraction: totalFraction);
    }

    for (var q in quantities) {
      final fraction = q.toFraction();
      totalFraction.add(fraction);
    }

    // 约分
    int gcdValue = gcd(totalFraction.numerator!, totalFraction.denominator!);
    int numerator = totalFraction.numerator! ~/ gcdValue;
    int denominator = totalFraction.denominator! ~/ gcdValue;

    int newQty = numerator ~/ denominator;
    int newNumerator = numerator % denominator;
    int newDenominator = denominator;

    if (newNumerator == 0) {
      return QuantityModel(qty: newQty, fraction: FractionModel(null, null));
    } else {
      return QuantityModel(
        qty: newQty,
        fraction: FractionModel(newNumerator, newDenominator),
      );
    }
  }

  static int gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a.abs();
  }
}
