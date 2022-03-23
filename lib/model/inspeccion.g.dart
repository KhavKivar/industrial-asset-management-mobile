// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspeccion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspeccionAdapter extends TypeAdapter<Inspeccion> {
  @override
  final int typeId = 2;

  @override
  Inspeccion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Inspeccion(
      idInspeccion: fields[0] as int?,
      alarmaRetroceso: fields[1] as String?,
      asientoOperador: fields[2] as String?,
      baliza: fields[3] as String?,
      idEquipo: fields[4] as int?,
      bocina: fields[5] as String?,
      extintor: fields[6] as String?,
      espejos: fields[7] as String?,
      cantidadEspejos: fields[8] as int?,
      focosFaenerosDelanteros: fields[9] as String?,
      cantidadFocosFaenerosDelanteros: fields[10] as int?,
      focosFaenerosTraseros: fields[11] as String?,
      cantidadFocosFaenerosTraseros: fields[12] as int?,
      llaveContacto: fields[13] as String?,
      cantidadLlaveContacto: fields[14] as int?,
      intermitentesDelanteros: fields[15] as String?,
      cantidadIntermitentesDelanteros: fields[16] as int?,
      intermitentesTraseros: fields[17] as String?,
      cantidadIntermitentesTraseros: fields[18] as int?,
      palancaFrenoMano: fields[19] as String?,
      peraVolante: fields[20] as String?,
      arnesCilindroGas: fields[21] as String?,
      tableroIntrumentos: fields[22] as String?,
      cilindroDesplazador: fields[23] as String?,
      cilindroDireccion: fields[24] as String?,
      cilindroLevanteCentral: fields[25] as String?,
      cilindroInclinacion: fields[26] as String?,
      cilindroLevanteLateral: fields[27] as String?,
      flexibleHidraulico: fields[28] as String?,
      fugaConectores: fields[29] as String?,
      alternador: fields[30] as String?,
      bateria: fields[31] as String?,
      chapaContacto: fields[32] as String?,
      sistemaElectrico: fields[33] as String?,
      horometro: fields[34] as String?,
      motorPartida: fields[35] as String?,
      palancaComando: fields[36] as String?,
      switchLuces: fields[37] as String?,
      switchMarcha: fields[38] as String?,
      cadena: fields[39] as String?,
      carro: fields[40] as String?,
      horquilla: fields[41] as String?,
      jaula: fields[42] as String?,
      llantas: fields[43] as String?,
      mastil: fields[44] as String?,
      pintura: fields[45] as String?,
      rueda: fields[46] as String?,
      cantidadRueda: fields[47] as int?,
      desplazadorLateral: fields[48] as String?,
      direccion: fields[49] as String?,
      frenoMano: fields[50] as String?,
      frenoPie: fields[51] as String?,
      inclinacion: fields[52] as String?,
      levante: fields[53] as String?,
      motor: fields[54] as String?,
      nivelAceiteHidraulico: fields[55] as String?,
      nivelAceiteMotor: fields[56] as String?,
      nivelAceiteTransmision: fields[57] as String?,
      nivelLiquinoFreno: fields[58] as String?,
      tapaCombustible: fields[59] as String?,
      tapaRadiador: fields[60] as String?,
      transmision: fields[61] as String?,
      observacion: fields[62] as String?,
      firmaUrl: fields[63] as String?,
      rut: fields[64] as String?,
      nombre: fields[65] as String?,
      joystick: fields[66] as String?,
      cargadorVoltaje: fields[68] as String?,
      enchufe: fields[69] as String?,
      serieCargador: fields[67] as String?,
      tipo: fields[70] as String?,
      alturaLevante: fields[71] as String?,
      carga: fields[72] as int?,
      bateriaObservaciones: fields[74] as String?,
      serieCargardorText: fields[75] as String?,
      cargadorVoltajeInfo: fields[76] as String?,
      enchufeInfo: fields[77] as String?,
      cilindroDeGas: fields[73] as int?,
      horometroActual: fields[78] as double?,
      mastilEquipo: fields[79] as String?,
      ts: fields[86] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Inspeccion obj) {
    writer
      ..writeByte(81)
      ..writeByte(0)
      ..write(obj.idInspeccion)
      ..writeByte(1)
      ..write(obj.alarmaRetroceso)
      ..writeByte(2)
      ..write(obj.asientoOperador)
      ..writeByte(3)
      ..write(obj.baliza)
      ..writeByte(4)
      ..write(obj.idEquipo)
      ..writeByte(5)
      ..write(obj.bocina)
      ..writeByte(6)
      ..write(obj.extintor)
      ..writeByte(7)
      ..write(obj.espejos)
      ..writeByte(8)
      ..write(obj.cantidadEspejos)
      ..writeByte(9)
      ..write(obj.focosFaenerosDelanteros)
      ..writeByte(10)
      ..write(obj.cantidadFocosFaenerosDelanteros)
      ..writeByte(11)
      ..write(obj.focosFaenerosTraseros)
      ..writeByte(12)
      ..write(obj.cantidadFocosFaenerosTraseros)
      ..writeByte(13)
      ..write(obj.llaveContacto)
      ..writeByte(14)
      ..write(obj.cantidadLlaveContacto)
      ..writeByte(15)
      ..write(obj.intermitentesDelanteros)
      ..writeByte(16)
      ..write(obj.cantidadIntermitentesDelanteros)
      ..writeByte(17)
      ..write(obj.intermitentesTraseros)
      ..writeByte(18)
      ..write(obj.cantidadIntermitentesTraseros)
      ..writeByte(19)
      ..write(obj.palancaFrenoMano)
      ..writeByte(20)
      ..write(obj.peraVolante)
      ..writeByte(21)
      ..write(obj.arnesCilindroGas)
      ..writeByte(22)
      ..write(obj.tableroIntrumentos)
      ..writeByte(23)
      ..write(obj.cilindroDesplazador)
      ..writeByte(24)
      ..write(obj.cilindroDireccion)
      ..writeByte(25)
      ..write(obj.cilindroLevanteCentral)
      ..writeByte(26)
      ..write(obj.cilindroInclinacion)
      ..writeByte(27)
      ..write(obj.cilindroLevanteLateral)
      ..writeByte(28)
      ..write(obj.flexibleHidraulico)
      ..writeByte(29)
      ..write(obj.fugaConectores)
      ..writeByte(30)
      ..write(obj.alternador)
      ..writeByte(31)
      ..write(obj.bateria)
      ..writeByte(32)
      ..write(obj.chapaContacto)
      ..writeByte(33)
      ..write(obj.sistemaElectrico)
      ..writeByte(34)
      ..write(obj.horometro)
      ..writeByte(35)
      ..write(obj.motorPartida)
      ..writeByte(36)
      ..write(obj.palancaComando)
      ..writeByte(37)
      ..write(obj.switchLuces)
      ..writeByte(38)
      ..write(obj.switchMarcha)
      ..writeByte(39)
      ..write(obj.cadena)
      ..writeByte(40)
      ..write(obj.carro)
      ..writeByte(41)
      ..write(obj.horquilla)
      ..writeByte(42)
      ..write(obj.jaula)
      ..writeByte(43)
      ..write(obj.llantas)
      ..writeByte(44)
      ..write(obj.mastil)
      ..writeByte(45)
      ..write(obj.pintura)
      ..writeByte(46)
      ..write(obj.rueda)
      ..writeByte(47)
      ..write(obj.cantidadRueda)
      ..writeByte(48)
      ..write(obj.desplazadorLateral)
      ..writeByte(49)
      ..write(obj.direccion)
      ..writeByte(50)
      ..write(obj.frenoMano)
      ..writeByte(51)
      ..write(obj.frenoPie)
      ..writeByte(52)
      ..write(obj.inclinacion)
      ..writeByte(53)
      ..write(obj.levante)
      ..writeByte(54)
      ..write(obj.motor)
      ..writeByte(55)
      ..write(obj.nivelAceiteHidraulico)
      ..writeByte(56)
      ..write(obj.nivelAceiteMotor)
      ..writeByte(57)
      ..write(obj.nivelAceiteTransmision)
      ..writeByte(58)
      ..write(obj.nivelLiquinoFreno)
      ..writeByte(59)
      ..write(obj.tapaCombustible)
      ..writeByte(60)
      ..write(obj.tapaRadiador)
      ..writeByte(61)
      ..write(obj.transmision)
      ..writeByte(62)
      ..write(obj.observacion)
      ..writeByte(63)
      ..write(obj.firmaUrl)
      ..writeByte(64)
      ..write(obj.rut)
      ..writeByte(65)
      ..write(obj.nombre)
      ..writeByte(66)
      ..write(obj.joystick)
      ..writeByte(67)
      ..write(obj.serieCargador)
      ..writeByte(68)
      ..write(obj.cargadorVoltaje)
      ..writeByte(69)
      ..write(obj.enchufe)
      ..writeByte(70)
      ..write(obj.tipo)
      ..writeByte(71)
      ..write(obj.alturaLevante)
      ..writeByte(72)
      ..write(obj.carga)
      ..writeByte(73)
      ..write(obj.cilindroDeGas)
      ..writeByte(74)
      ..write(obj.bateriaObservaciones)
      ..writeByte(75)
      ..write(obj.serieCargardorText)
      ..writeByte(76)
      ..write(obj.cargadorVoltajeInfo)
      ..writeByte(77)
      ..write(obj.enchufeInfo)
      ..writeByte(78)
      ..write(obj.horometroActual)
      ..writeByte(79)
      ..write(obj.mastilEquipo)
      ..writeByte(86)
      ..write(obj.ts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspeccionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
