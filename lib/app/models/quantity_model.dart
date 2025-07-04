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

  void substract(FractionModel fraction) {
    if (isEmpty && fraction.isEmpty) return;
    int num = numerator ?? 0;
    int den = denominator ?? 1;
    int n = fraction.numerator ?? 0;
    int d = fraction.denominator ?? 1;

    numerator = num * d - n * den;
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

  void substract(QuantityModel model) {
    if (fraction.isEmpty && model.fraction.isEmpty) {
      qty -= model.qty;
      return;
    }
    final f = toFraction();
    final fm = model.toFraction();
    f.substract(fm);
    final r = cancelling(f);
    qty = r.qty;
    fraction = r.fraction;
  }

  static QuantityModel sumQuantities(List<QuantityModel> quantities) {
    assert(
      quantities.every(
        (q) =>
            q.qty >= 0 &&
            (q.fraction.numerator == null
                ? true
                : q.fraction.numerator! >= 0) &&
            (q.fraction.denominator == null
                ? true
                : q.fraction.denominator! >= 0),
      ),
    );

    final totalFraction = FractionModel(null, null);

    if (quantities.every((e) => e.fraction.isEmpty)) {
      int totalQty = quantities.fold(0, (sum, q) => sum + q.qty);
      return QuantityModel(qty: totalQty, fraction: totalFraction);
    }

    for (var q in quantities) {
      final fraction = q.toFraction();
      totalFraction.add(fraction);
    }

    return cancelling(totalFraction);
  }

  static QuantityModel cancelling(FractionModel fraction) {
    // 约分
    int gcdValue = gcd(fraction.numerator!, fraction.denominator!);
    int numerator = fraction.numerator! ~/ gcdValue;
    int denominator = fraction.denominator! ~/ gcdValue;

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

  @override
  bool operator ==(Object other) {
    if (other is QuantityModel) {
      return qty == other.qty &&
          fraction == other.fraction &&
          unit == other.unit;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(qty, fraction, unit);

  QuantityModel copyWith({int? qty, String? unit, FractionModel? fraction}) {
    return QuantityModel(
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      fraction:
          fraction ??
          FractionModel(this.fraction.numerator, this.fraction.denominator),
    );
  }
}
