// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 5;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      quantities: (fields[1] as List).cast<Quantity>(),
      pillId: fields[3] as String,
      planId: fields[4] as String?,
      timestamp: fields[5] as DateTime,
      remark: fields[6] as String?,
      isCustom: fields[7] as bool,
      startTime: fields[8] as DateTime,
      endTime: fields[9] as DateTime?,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quantities)
      ..writeByte(3)
      ..write(obj.pillId)
      ..writeByte(4)
      ..write(obj.planId)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.remark)
      ..writeByte(7)
      ..write(obj.isCustom)
      ..writeByte(8)
      ..write(obj.startTime)
      ..writeByte(9)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuantityAdapter extends TypeAdapter<Quantity> {
  @override
  final int typeId = 6;

  @override
  Quantity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quantity(
      qty: fields[0] as int,
      unit: fields[1] as String,
      numerator: fields[2] as int?,
      denominator: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Quantity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.qty)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.numerator)
      ..writeByte(3)
      ..write(obj.denominator);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuantityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
