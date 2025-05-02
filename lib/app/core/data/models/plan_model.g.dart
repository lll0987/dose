// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanModelAdapter extends TypeAdapter<PlanModel> {
  @override
  final int typeId = 1;

  @override
  PlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanModel(
      pillId: fields[1] as String,
      isEnabled: fields[2] as bool,
      name: fields[3] as String,
      qty: fields[4] as int,
      unit: fields[5] as String,
      numerator: fields[18] as int?,
      denominator: fields[19] as int?,
      startDate: fields[6] as String,
      endDate: fields[7] as String,
      repeatValues: (fields[12] as List).cast<int>(),
      repeatUnit: fields[13] as String,
      startTime: fields[9] as String,
      isExactTime: fields[8] as bool,
      duration: fields[11] as int?,
      durationUnit: fields[10] as String?,
      reminderValue: fields[14] as int?,
      reminderUnit: fields[15] as String?,
      reminderMethod: fields[16] as String?,
      cycles: (fields[17] as List).cast<Cycle>(),
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, PlanModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pillId)
      ..writeByte(2)
      ..write(obj.isEnabled)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.qty)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(18)
      ..write(obj.numerator)
      ..writeByte(19)
      ..write(obj.denominator)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.isExactTime)
      ..writeByte(9)
      ..write(obj.startTime)
      ..writeByte(10)
      ..write(obj.durationUnit)
      ..writeByte(11)
      ..write(obj.duration)
      ..writeByte(12)
      ..write(obj.repeatValues)
      ..writeByte(13)
      ..write(obj.repeatUnit)
      ..writeByte(14)
      ..write(obj.reminderValue)
      ..writeByte(15)
      ..write(obj.reminderUnit)
      ..writeByte(16)
      ..write(obj.reminderMethod)
      ..writeByte(17)
      ..write(obj.cycles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CycleAdapter extends TypeAdapter<Cycle> {
  @override
  final int typeId = 2;

  @override
  Cycle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cycle(
      value: fields[0] as int,
      unit: fields[1] as String,
      isStop: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Cycle obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.isStop);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
