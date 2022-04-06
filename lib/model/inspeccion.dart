// To parse this JSON data, do
//
//     final inspeccion = inspeccionFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';

part 'inspeccion.g.dart';

List<Inspeccion> inspeccionFromJson(String str) =>
    List<Inspeccion>.from(json.decode(str).map((x) => Inspeccion.fromJson(x)));

String inspeccionToJson(List<Inspeccion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 2)
class Inspeccion extends HiveObject with EquatableMixin {
  Inspeccion({
    this.idInspeccion,
    this.alarmaRetroceso,
    this.asientoOperador,
    this.baliza,
    this.idEquipo,
    this.bocina,
    this.extintor,
    this.espejos,
    this.cantidadEspejos,
    this.focosFaenerosDelanteros,
    this.cantidadFocosFaenerosDelanteros,
    this.focosFaenerosTraseros,
    this.cantidadFocosFaenerosTraseros,
    this.llaveContacto,
    this.cantidadLlaveContacto,
    this.intermitentesDelanteros,
    this.cantidadIntermitentesDelanteros,
    this.intermitentesTraseros,
    this.cantidadIntermitentesTraseros,
    this.palancaFrenoMano,
    this.peraVolante,
    this.arnesCilindroGas,
    this.tableroIntrumentos,
    this.cilindroDesplazador,
    this.cilindroDireccion,
    this.cilindroLevanteCentral,
    this.cilindroInclinacion,
    this.cilindroLevanteLateral,
    this.flexibleHidraulico,
    this.fugaConectores,
    this.alternador,
    this.bateria,
    this.chapaContacto,
    this.sistemaElectrico,
    this.horometro,
    this.motorPartida,
    this.palancaComando,
    this.switchLuces,
    this.switchMarcha,
    this.cadena,
    this.carro,
    this.horquilla,
    this.jaula,
    this.llantas,
    this.mastil,
    this.pintura,
    this.rueda,
    this.cantidadRueda,
    this.desplazadorLateral,
    this.direccion,
    this.frenoMano,
    this.frenoPie,
    this.inclinacion,
    this.levante,
    this.motor,
    this.nivelAceiteHidraulico,
    this.nivelAceiteMotor,
    this.nivelAceiteTransmision,
    this.nivelLiquinoFreno,
    this.tapaCombustible,
    this.tapaRadiador,
    this.transmision,
    this.observacion,
    this.firmaUrl,
    this.rut,
    this.nombre,
    this.joystick,
    this.cargadorVoltaje,
    this.enchufe,
    this.serieCargador,
    this.tipo,
    this.alturaLevante,
    this.carga,
    this.bateriaObservaciones,
    this.serieCargardorText,
    this.cargadorVoltajeInfo,
    this.enchufeInfo,
    this.cilindroDeGas,
    this.horometroActual,
    this.mastilEquipo,
    this.ts,
  });
  @HiveField(0)
  int? idInspeccion;

  @HiveField(1)
  String? alarmaRetroceso;

  @HiveField(2)
  String? asientoOperador;

  @HiveField(3)
  String? baliza;

  @HiveField(4)
  int? idEquipo;

  @HiveField(5)
  String? bocina;

  @HiveField(6)
  String? extintor;

  @HiveField(7)
  String? espejos;

  @HiveField(8)
  int? cantidadEspejos;

  @HiveField(9)
  String? focosFaenerosDelanteros;

  @HiveField(10)
  int? cantidadFocosFaenerosDelanteros;

  @HiveField(11)
  String? focosFaenerosTraseros;

  @HiveField(12)
  int? cantidadFocosFaenerosTraseros;

  @HiveField(13)
  String? llaveContacto;

  @HiveField(14)
  int? cantidadLlaveContacto;

  @HiveField(15)
  String? intermitentesDelanteros;

  @HiveField(16)
  int? cantidadIntermitentesDelanteros;

  @HiveField(17)
  String? intermitentesTraseros;

  @HiveField(18)
  int? cantidadIntermitentesTraseros;

  @HiveField(19)
  String? palancaFrenoMano;

  @HiveField(20)
  String? peraVolante;

  @HiveField(21)
  String? arnesCilindroGas;

  @HiveField(22)
  String? tableroIntrumentos;

  @HiveField(23)
  String? cilindroDesplazador;

  @HiveField(24)
  String? cilindroDireccion;

  @HiveField(25)
  String? cilindroLevanteCentral;

  @HiveField(26)
  String? cilindroInclinacion;

  @HiveField(27)
  String? cilindroLevanteLateral;

  @HiveField(28)
  String? flexibleHidraulico;

  @HiveField(29)
  String? fugaConectores;

  @HiveField(30)
  String? alternador;

  @HiveField(31)
  String? bateria;
  @HiveField(32)
  String? chapaContacto;
  @HiveField(33)
  String? sistemaElectrico;
  @HiveField(34)
  String? horometro;
  @HiveField(35)
  String? motorPartida;
  @HiveField(36)
  String? palancaComando;
  @HiveField(37)
  String? switchLuces;
  @HiveField(38)
  String? switchMarcha;
  @HiveField(39)
  String? cadena;
  @HiveField(40)
  String? carro;
  @HiveField(41)
  String? horquilla;
  @HiveField(42)
  String? jaula;
  @HiveField(43)
  String? llantas;
  @HiveField(44)
  String? mastil;
  @HiveField(45)
  String? pintura;
  @HiveField(46)
  String? rueda;
  @HiveField(47)
  int? cantidadRueda;
  @HiveField(48)
  String? desplazadorLateral;
  @HiveField(49)
  String? direccion;
  @HiveField(50)
  String? frenoMano;
  @HiveField(51)
  String? frenoPie;
  @HiveField(52)
  String? inclinacion;
  @HiveField(53)
  String? levante;
  @HiveField(54)
  String? motor;
  @HiveField(55)
  String? nivelAceiteHidraulico;
  @HiveField(56)
  String? nivelAceiteMotor;
  @HiveField(57)
  String? nivelAceiteTransmision;
  @HiveField(58)
  String? nivelLiquinoFreno;
  @HiveField(59)
  String? tapaCombustible;
  @HiveField(60)
  String? tapaRadiador;
  @HiveField(61)
  String? transmision;
  @HiveField(62)
  String? observacion;
  @HiveField(63)
  String? firmaUrl;
  @HiveField(64)
  String? rut;
  @HiveField(65)
  String? nombre;
  @HiveField(66)
  String? joystick;
  @HiveField(67)
  String? serieCargador;
  @HiveField(68)
  String? cargadorVoltaje;
  @HiveField(69)
  String? enchufe;
  @HiveField(70)
  String? tipo;
  @HiveField(71)
  String? alturaLevante;
  @HiveField(72)
  int? carga;
  @HiveField(73)
  int? cilindroDeGas;
  @HiveField(74)
  String? bateriaObservaciones;
  @HiveField(75)
  String? serieCargardorText;
  @HiveField(76)
  String? cargadorVoltajeInfo;
  @HiveField(77)
  String? enchufeInfo;
  @HiveField(78)
  double? horometroActual;

  @HiveField(79)
  String? mastilEquipo;

  @HiveField(86)
  DateTime? ts;

  factory Inspeccion.fromJson(Map<String, dynamic> json) => Inspeccion(
        idInspeccion: json["idInspeccion"],
        alarmaRetroceso: json["alarmaRetroceso"],
        asientoOperador: json["asientoOperador"],
        baliza: json["baliza"],
        idEquipo: json["idEquipo"],
        bocina: json["bocina"],
        extintor: json["extintor"],
        espejos: json["espejos"],
        cantidadEspejos: json["cantidadEspejos"],
        focosFaenerosDelanteros: json["focosFaenerosDelanteros"],
        cantidadFocosFaenerosDelanteros:
            json["cantidadFocosFaenerosDelanteros"],
        focosFaenerosTraseros: json["focosFaenerosTraseros"],
        cantidadFocosFaenerosTraseros: json["cantidadFocosFaenerosTraseros"],
        llaveContacto: json["llaveContacto"],
        cantidadLlaveContacto: json["cantidadLlaveContacto"],
        intermitentesDelanteros: json["intermitentesDelanteros"],
        cantidadIntermitentesDelanteros:
            json["cantidadIntermitentesDelanteros"],
        intermitentesTraseros: json["intermitentesTraseros"],
        cantidadIntermitentesTraseros: json["cantidadIntermitentesTraseros"],
        palancaFrenoMano: json["palancaFrenoMano"],
        peraVolante: json["peraVolante"],
        arnesCilindroGas: json["arnesCilindroGas"],
        tableroIntrumentos: json["tableroIntrumentos"],
        cilindroDesplazador: json["cilindroDesplazador"],
        cilindroDireccion: json["cilindroDireccion"],
        cilindroLevanteCentral: json["cilindroLevanteCentral"],
        cilindroInclinacion: json["cilindroInclinacion"],
        cilindroLevanteLateral: json["cilindroLevanteLateral"],
        flexibleHidraulico: json["flexibleHidraulico"],
        fugaConectores: json["fugaConectores"],
        alternador: json["alternador"],
        bateria: json["bateria"],
        chapaContacto: json["chapaContacto"],
        sistemaElectrico: json["sistemaElectrico"],
        horometro: json["horometro"],
        motorPartida: json["motorPartida"],
        palancaComando: json["palancaComando"],
        switchLuces: json["switchLuces"],
        switchMarcha: json["switchMarcha"],
        cadena: json["cadena"],
        carro: json["carro"],
        horquilla: json["horquilla"],
        jaula: json["jaula"],
        llantas: json["llantas"],
        mastil: json["mastil"],
        pintura: json["pintura"],
        rueda: json["rueda"],
        cantidadRueda: json["cantidadRueda"],
        desplazadorLateral: json["desplazadorLateral"],
        direccion: json["direccion"],
        frenoMano: json["frenoMano"],
        frenoPie: json["frenoPie"],
        inclinacion: json["inclinacion"],
        levante: json["levante"],
        motor: json["motor"],
        nivelAceiteHidraulico: json["nivelAceiteHidraulico"],
        nivelAceiteMotor: json["nivelAceiteMotor"],
        nivelAceiteTransmision: json["nivelAceiteTransmision"],
        nivelLiquinoFreno: json["nivelLiquinoFreno"],
        tapaCombustible: json["tapaCombustible"],
        tapaRadiador: json["tapaRadiador"],
        transmision: json["transmision"],
        observacion: json["observacion"],
        firmaUrl: json["firmaURL"],
        rut: json["rut"],
        nombre: json["nombre"],
        tipo: json["tipo"],
        joystick: json["joystick"],
        serieCargador: json["serieCargador"],
        cargadorVoltaje: json["cargadorVoltaje"],
        enchufe: json["enchufe"],
        alturaLevante: json["alturaLevante"],
        carga: json["carga"],
        cilindroDeGas: json["cilindroDeGas"],
        bateriaObservaciones: json["bateriaObservaciones"],
        serieCargardorText: json["serieCargardorText"],
        cargadorVoltajeInfo: json["cargadorVoltajeInfo"],
        enchufeInfo: json["enchufeInfo"],
        horometroActual: json["horometroActual"].toDouble(),
        mastilEquipo: json["mastilEquipo"],
        ts: DateTime.parse(json["ts"]),
      );

  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "alarmaRetroceso": alarmaRetroceso,
        "asientoOperador": asientoOperador,
        "baliza": baliza,
        "idEquipo": idEquipo,
        "bocina": bocina,
        "extintor": extintor,
        "espejos": espejos,
        "cantidadEspejos": cantidadEspejos,
        "focosFaenerosDelanteros": focosFaenerosDelanteros,
        "cantidadFocosFaenerosDelanteros": cantidadFocosFaenerosDelanteros,
        "focosFaenerosTraseros": focosFaenerosTraseros,
        "cantidadFocosFaenerosTraseros": cantidadFocosFaenerosTraseros,
        "llaveContacto": llaveContacto,
        "cantidadLlaveContacto": cantidadLlaveContacto,
        "intermitentesDelanteros": intermitentesDelanteros,
        "cantidadIntermitentesDelanteros": cantidadIntermitentesDelanteros,
        "intermitentesTraseros": intermitentesTraseros,
        "cantidadIntermitentesTraseros": cantidadIntermitentesTraseros,
        "palancaFrenoMano": palancaFrenoMano,
        "peraVolante": peraVolante,
        "arnesCilindroGas": arnesCilindroGas == null ? null : arnesCilindroGas,
        "tableroIntrumentos": tableroIntrumentos,
        "cilindroDesplazador": cilindroDesplazador,
        "cilindroDireccion": cilindroDireccion,
        "cilindroLevanteCentral": cilindroLevanteCentral,
        "cilindroInclinacion": cilindroInclinacion,
        "cilindroLevanteLateral": cilindroLevanteLateral,
        "flexibleHidraulico": flexibleHidraulico,
        "fugaConectores": fugaConectores,
        "alternador": alternador == null ? null : alternador,
        "bateria": bateria,
        "chapaContacto": chapaContacto,
        "sistemaElectrico": sistemaElectrico,
        "horometro": horometro,
        "motorPartida": motorPartida == null ? null : motorPartida,
        "palancaComando": palancaComando,
        "switchLuces": switchLuces,
        "switchMarcha": switchMarcha,
        "joystick": joystick == null ? null : joystick,
        "cadena": cadena,
        "carro": carro,
        "horquilla": horquilla,
        "jaula": jaula,
        "llantas": llantas,
        "mastil": mastil,
        "pintura": pintura,
        "rueda": rueda,
        "cantidadRueda": cantidadRueda.toString(),
        "desplazadorLateral": desplazadorLateral,
        "direccion": direccion,
        "frenoMano": frenoMano,
        "frenoPie": frenoPie,
        "inclinacion": inclinacion,
        "levante": levante,
        "motor": motor == null ? null : motor,
        "serieCargador": serieCargador == null ? null : serieCargador,
        "nivelAceiteHidraulico": nivelAceiteHidraulico,
        "nivelAceiteMotor": nivelAceiteMotor == null ? null : nivelAceiteMotor,
        "nivelAceiteTransmision":
            nivelAceiteTransmision == null ? null : nivelAceiteTransmision,
        "nivelLiquinoFreno": nivelLiquinoFreno,
        "tapaCombustible": tapaCombustible == null ? null : tapaCombustible,
        "tapaRadiador": tapaRadiador == null ? null : tapaRadiador,
        "transmision": transmision == null ? null : transmision,
        "cargadorVoltaje": cargadorVoltaje == null ? null : cargadorVoltaje,
        "enchufe": enchufe == null ? null : enchufe,
        "observacion": observacion,
        "alturaLevante": alturaLevante,
        "carga": carga,
        "cilindroDeGas": cilindroDeGas == null ? null : cilindroDeGas,
        "bateriaObservaciones":
            bateriaObservaciones == null ? null : bateriaObservaciones,
        "serieCargardorText":
            serieCargardorText == null ? null : serieCargardorText,
        "cargadorVoltajeInfo":
            cargadorVoltajeInfo == null ? null : cargadorVoltajeInfo,
        "enchufeInfo": enchufeInfo == null ? null : enchufeInfo,
        "horometroActual": horometroActual.toString(),
        "mastilEquipo": mastilEquipo,
        "firmaURL": firmaUrl,
        "rut": rut,
        "nombre": nombre,
      };

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
      idInspeccion,
      alarmaRetroceso,
      asientoOperador,
      baliza,
      idEquipo,
      bocina,
      extintor,
      espejos,
      cantidadEspejos,
      focosFaenerosDelanteros,
      cantidadFocosFaenerosDelanteros,
      focosFaenerosTraseros,
      cantidadFocosFaenerosTraseros,
      llaveContacto,
      cantidadLlaveContacto,
      intermitentesDelanteros,
      cantidadIntermitentesDelanteros,
      intermitentesTraseros,
      cantidadIntermitentesTraseros,
      palancaFrenoMano,
      peraVolante,
      arnesCilindroGas,
      tableroIntrumentos,
      cilindroDesplazador,
      cilindroDireccion,
      cilindroLevanteCentral,
      cilindroInclinacion,
      cilindroLevanteLateral,
      flexibleHidraulico,
      fugaConectores,
      alternador,
      bateria,
      chapaContacto,
      sistemaElectrico,
      horometro,
      motorPartida,
      palancaComando,
      switchLuces,
      switchMarcha,
      cadena,
      carro,
      horquilla,
      jaula,
      llantas,
      mastil,
      pintura,
      rueda,
      cantidadRueda,
      desplazadorLateral,
      direccion,
      frenoMano,
      frenoPie,
      inclinacion,
      levante,
      motor,
      nivelAceiteHidraulico,
      nivelAceiteMotor,
      nivelAceiteTransmision,
      nivelLiquinoFreno,
      tapaCombustible,
      tapaRadiador,
      transmision,
      observacion,
      firmaUrl,
      rut,
      nombre,
      joystick,
      cargadorVoltaje,
      enchufe,
      serieCargador,
      tipo,
      alturaLevante,
      carga,
      bateriaObservaciones,
      serieCargardorText,
      cargadorVoltajeInfo,
      enchufeInfo,
      cilindroDeGas,
      horometroActual,
      mastilEquipo,
      ts
    ];
  }
}
