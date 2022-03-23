// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipoAdapter extends TypeAdapter<Equipo> {
  @override
  final int typeId = 0;

  @override
  Equipo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Equipo(
      id: fields[0] as int,
      tipo: fields[1] as String,
      marca: fields[2] as String,
      modelo: fields[3] as String,
      serie: fields[4] as String,
      capacidad: fields[5] as int,
      mastil: fields[6] as String,
      altura: fields[7] as double,
      ano: fields[8] as String,
      horometro: fields[9] as double,
      precioNeto: fields[12] as int,
      estado: fields[10] as String,
      ubicacion: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Equipo obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tipo)
      ..writeByte(2)
      ..write(obj.marca)
      ..writeByte(3)
      ..write(obj.modelo)
      ..writeByte(4)
      ..write(obj.serie)
      ..writeByte(5)
      ..write(obj.capacidad)
      ..writeByte(6)
      ..write(obj.mastil)
      ..writeByte(7)
      ..write(obj.altura)
      ..writeByte(8)
      ..write(obj.ano)
      ..writeByte(9)
      ..write(obj.horometro)
      ..writeByte(10)
      ..write(obj.estado)
      ..writeByte(11)
      ..write(obj.ubicacion)
      ..writeByte(12)
      ..write(obj.precioNeto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
