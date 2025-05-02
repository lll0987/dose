// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PillModelAdapter extends TypeAdapter<PillModel> {
  @override
  final int typeId = 3;

  @override
  PillModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PillModel(
      name: fields[1] as String,
      imagePath: fields[2] as String?,
      initialQty: fields[3] as int,
      initialUnit: fields[6] as String,
      initialNum: fields[4] as int?,
      initialDen: fields[9] as int?,
      qty: fields[5] as int,
      numerator: fields[10] as int?,
      denominator: fields[12] as int?,
      preferredUnit: fields[11] as String?,
      themeValue: fields[7] as int?,
      packSpecs: (fields[8] as List).cast<Spec>(),
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, PillModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.initialQty)
      ..writeByte(6)
      ..write(obj.initialUnit)
      ..writeByte(4)
      ..write(obj.initialNum)
      ..writeByte(9)
      ..write(obj.initialDen)
      ..writeByte(5)
      ..write(obj.qty)
      ..writeByte(10)
      ..write(obj.numerator)
      ..writeByte(12)
      ..write(obj.denominator)
      ..writeByte(11)
      ..write(obj.preferredUnit)
      ..writeByte(7)
      ..write(obj.themeValue)
      ..writeByte(8)
      ..write(obj.packSpecs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PillModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpecAdapter extends TypeAdapter<Spec> {
  @override
  final int typeId = 4;

  @override
  Spec read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Spec(
      qty: fields[0] as int,
      unit: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Spec obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.qty)
      ..writeByte(1)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
