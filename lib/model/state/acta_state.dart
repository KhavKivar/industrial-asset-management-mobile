import 'dart:convert';

import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/state/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../equipo.dart';
import 'package:app_licman/plugins/dart_rut_form.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class AuxSelectItem {
  AuxSelectItem(
      {required this.text,
      required this.select,
      required this.tipo,
      required this.options});
  String text;
  String select;
  String tipo;
  List<String> options;

  factory AuxSelectItem.fromJson(Map<String, dynamic> json) => AuxSelectItem(
        text: json["text"],
        select: json["select"],
        tipo: json["tipo"],
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "select": select,
        "tipo": tipo,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}

String? convertBoolToString(List<bool>? listValue) {
  if (listValue == null) {
    return null;
  }
  if (listValue[0]) {
    return "bueno";
  } else if (listValue[1]) {
    return "regular";
  } else if (listValue[2]) {
    return "malo";
  }
  return null;
}

class ActaState extends ChangeNotifier {
  late final Map<String, dynamic> MapOfValue;

  Inspeccion convertMapToObject(String signUrl) {
    Inspeccion acta = Inspeccion();
    acta.tipo = MapOfValue['tipo'] ? "acta_equipo" : "acta_electrica";

    acta.idEquipo = int.parse(MapOfValue['id']);
    acta.rut = MapOfValue['rut'].replaceAll(".", "");
    acta.nombre = MapOfValue['name'];
    acta.observacion = MapOfValue['obv'];
    acta.alturaLevante = MapOfValue['alturaLevante'];
    acta.horometroActual = double.parse(MapOfValue['horometroActual']);

    print("value ${MapOfValue['mastilEquipo']}");

    acta.mastilEquipo = MapOfValue['mastilEquipo'] == 'Simple'
        ? "SIMPLE"
        : MapOfValue['mastilEquipo'] == 'Doble'
            ? "DOBLE"
            : "TRIPLE";

    acta.firmaUrl = signUrl;

    //1 camp

    acta.alarmaRetroceso = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Alarma retroceso']);

    print(
        "alarma retroceso ${MapOfValue['ACTA']['SELECT_CAMP'][0]['Alarma retroceso']}");

    acta.extintor =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][0]['Extintor']);
    acta.espejos =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][0]['Espejos']);

    acta.focosFaenerosDelanteros = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Focos faeneros delanteros']);

    acta.focosFaenerosTraseros = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Focos faeneros traseros']);
    acta.llaveContacto = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['LLave de contacto']);

    acta.asientoOperador = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Asiento operdor']);
    acta.baliza =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][0]['Baliza']);
    acta.bocina =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][0]['Bocina']);

    acta.intermitentesDelanteros = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Intermitentes delanteros']);
    acta.intermitentesTraseros = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Focos faeneros traseros']);
    acta.palancaFrenoMano = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Palanca freno mano']);
    acta.peraVolante = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Pera de volante']);
    acta.arnesCilindroGas = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Pera de volante']);
    acta.tableroIntrumentos = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][0]['Tablero instrumentos']);

    // 2 camp

    acta.cilindroDesplazador = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][1]['Cilindro desplazador']);
    if (acta.tipo == "acta_equipo") {
      acta.cilindroDireccion = convertBoolToString(
          MapOfValue['ACTA']['SELECT_CAMP'][1]['Cilindro direccion']);
    } else {
      acta.cilindroDireccion = convertBoolToString(
          MapOfValue['ACTA']['SELECT_CAMP'][1]['Cilindro direccion cadena']);
    }

    acta.cilindroLevanteCentral = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][1]['Cilindro levante central']);
    acta.cilindroInclinacion = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][1]['Cilindro inclinacion']);
    acta.cilindroLevanteLateral = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][1]['Cilindro levante laterales']);
    acta.flexibleHidraulico = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][1]['Flexibles hidraulicas']);
    acta.fugaConectores = convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP']
        [1]['Fuga por conectores y mangueras']);

    //3 camp
    acta.alternador =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][2]['Alternador']);
    acta.bateria =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][2]['Bateria']);
    acta.chapaContacto = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][2]['Chapa de contacto']);
    acta.sistemaElectrico = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][2]['Sistema electrico']);
    acta.horometro =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][2]['Horometro']);
    acta.motorPartida = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][2]['Motor de partida']);
    acta.palancaComando = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][2]['Palanca comandos']);
    acta.switchLuces = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][2]['Switch de luces']);
    acta.switchMarcha = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][2]['Switch de marchas']);
    acta.joystick =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][2]['Joystick']);
    //4 camp

    acta.cadena =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][3]['Cadenas']);
    acta.carro = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][3]['Carro y su respaldo de carga']);
    acta.horquilla = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][3]['Horquillas y seguros']);
    acta.jaula = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][3]['Jaula de proteccion']);
    acta.llantas =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][3]['LLantas']);
    acta.mastil =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][3]['Mastil']);
    acta.pintura =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][3]['Pintura']);
    acta.rueda =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][3]['Ruedas']);

    //5 camp

    acta.desplazadorLateral = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Desplazador lateral']);
    acta.direccion =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][4]['Direccion']);
    acta.frenoMano =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][4]['Freno mano']);
    acta.frenoPie =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][4]['Freno pie']);
    acta.inclinacion = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Inclinacion']);
    acta.levante =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][4]['Levante']);
    acta.motor =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][4]['Motor']);
    acta.nivelAceiteHidraulico = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Nivel aceite hidraulico']);
    acta.nivelAceiteMotor = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Nivel aceite motor']);
    acta.nivelAceiteTransmision = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Nivel aceite transmision']);
    acta.nivelLiquinoFreno = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Nivel liquido de freno']);
    acta.tapaCombustible = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Tapa combustible']);
    acta.tapaRadiador = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Tapa radiador']);
    acta.transmision = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Transmision']);
    acta.serieCargador = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Serie cargador']);

    acta.cargadorVoltaje = convertBoolToString(
        MapOfValue['ACTA']['SELECT_CAMP'][4]['Cargador voltaje y amperaje']);
    acta.enchufe =
        convertBoolToString(MapOfValue['ACTA']['SELECT_CAMP'][4]['Enchufes']);

    acta.carga = MapOfValue['ACTA']['OPTION_SELECT']
                    ['Carro y su respaldo de carga']
                .select ==
            "SI"
        ? 1
        : 0;
    if (acta.tipo == "acta_equipo") {
      acta.cilindroDeGas = MapOfValue['ACTA']['OPTION_SELECT']
                      ['Arnes de cilindro de gas']
                  .select ==
              "SI"
          ? 1
          : 0;
    } else {
      acta.bateriaObservaciones =
          MapOfValue['ACTA']['OPTION_SELECT']['Bateria'].select;
      acta.serieCargardorText =
          MapOfValue['ACTA']['OPTION_SELECT']['Serie cargador'].select;
      acta.cargadorVoltajeInfo = MapOfValue['ACTA']['OPTION_SELECT']
                      ['Cargador voltaje y amperaje']
                  .select ==
              "48V"
          ? "48"
          : "24";
      var enchufeText = MapOfValue['ACTA']['OPTION_SELECT']["Enchufes"]
              .select
              .split("A")[0] +
          "-" +
          MapOfValue['ACTA']['OPTION_SELECT']["Enchufes"].select[
              MapOfValue['ACTA']['OPTION_SELECT']["Enchufes"].select.length -
                  1];
      acta.enchufeInfo = enchufeText;
    }

    //Cantidad Camp

    acta.cantidadRueda = MapOfValue['ACTA']['TEXT_CAMP']['Ruedas'].length > 0
        ? int.parse(MapOfValue['ACTA']['TEXT_CAMP']['Ruedas'])
        : 0;

    acta.cantidadIntermitentesDelanteros =
        MapOfValue['ACTA']['TEXT_CAMP']['Intermitentes delanteros'].length == 0
            ? 0
            : int.parse(
                MapOfValue['ACTA']['TEXT_CAMP']['Intermitentes delanteros']);

    acta.cantidadIntermitentesTraseros = MapOfValue['ACTA']['TEXT_CAMP']
                    ['Intermitentes traseros']
                .length ==
            0
        ? 0
        : int.parse(MapOfValue['ACTA']['TEXT_CAMP']['Intermitentes traseros']);

    acta.cantidadLlaveContacto =
        MapOfValue['ACTA']['TEXT_CAMP']['LLave de contacto'].length == 0
            ? 0
            : int.parse(MapOfValue['ACTA']['TEXT_CAMP']['LLave de contacto']);

    acta.cantidadFocosFaenerosDelanteros =
        MapOfValue['ACTA']['TEXT_CAMP']['Focos faeneros delanteros'].length == 0
            ? 0
            : int.parse(
                MapOfValue['ACTA']['TEXT_CAMP']['Focos faeneros delanteros']);

    acta.cantidadFocosFaenerosTraseros = MapOfValue['ACTA']['TEXT_CAMP']
                    ['Focos faeneros traseros']
                .length ==
            0
        ? 0
        : int.parse(MapOfValue['ACTA']['TEXT_CAMP']['Focos faeneros traseros']);
    acta.cantidadEspejos =
        MapOfValue['ACTA']['TEXT_CAMP']['Espejos'].length == 0
            ? 0
            : int.parse(MapOfValue['ACTA']['TEXT_CAMP']['Espejos']);

    return acta;
  }

  init() {
    MapOfValue = {
      "id": "",
      "rut": "",
      "name": "",
      "obv": "",
      "equipo": null,
      "alturaLevante": "",
      "horometroActual": "",
      "mastilEquipo": null
    };
  }

  reset() {
    MapOfValue['id'] = "";
    MapOfValue['rut'] = "";
    MapOfValue['name'] = "";
    MapOfValue['obv'] = "";
    MapOfValue['equipo'] = null;
    MapOfValue['alturaLevante'] = "";
    MapOfValue['horometroActual'] = "";
    MapOfValue['tipo'] = true;
    MapOfValue['mastilEquipo'] = null;
    initMap(true);
    notifyListeners();
  }

  convertObjectTostate(Inspeccion acta, context) {
    MapOfValue['id'] = acta.idEquipo.toString();
    MapOfValue['rut'] = acta.rut.toString();
    MapOfValue['name'] = acta.nombre.toString();
    MapOfValue['obv'] = acta.observacion.toString();
    MapOfValue['equipo'] = Provider.of<AppState>(context, listen: false)
        .equipos
        .firstWhere((element) => element.id == acta.idEquipo);

    MapOfValue['alturaLevante'] = acta.alturaLevante.toString();
    MapOfValue['firmaUrl'] = acta.firmaUrl.toString();

    MapOfValue['mastilEquipo'] = acta.mastilEquipo?.toCapitalized();

    MapOfValue['horometroActual'] = acta.horometroActual.toString();
    MapOfValue['tipo'] = acta.tipo == "acta_equipo" ? true : false;
    if (acta.tipo == "acta_equipo") {
      MapOfValue['ACTA'] = {
        "OPTION_SELECT": {
          "Arnes de cilindro de gas": AuxSelectItem(
              text: "Cilindro de gas",
              tipo: "select",
              select: acta.cilindroDeGas == 1 ? "SI" : "NO",
              options: ["SI", "NO"]),
          'Carro y su respaldo de carga': AuxSelectItem(
              text: "Respaldo",
              tipo: "select",
              select: acta.carga == 1 ? "SI" : "NO",
              options: ["SI", "NO"]),
        },
        "TEXT_CAMP": {
          'Espejos': acta.cantidadEspejos.toString(),
          'Focos faeneros delanteros':
              acta.cantidadFocosFaenerosDelanteros.toString(),
          'Focos faeneros traseros':
              acta.cantidadFocosFaenerosTraseros.toString(),
          'LLave de contacto': acta.cantidadLlaveContacto.toString(),
          'Intermitentes delanteros':
              acta.cantidadIntermitentesDelanteros.toString(),
          'Intermitentes traseros':
              acta.cantidadIntermitentesTraseros.toString(),
          'Ruedas': acta.cantidadRueda.toString(),
        },
        "SELECT_CAMP": [
          {
            '': [false, false, false],
            'Alarma retroceso': convertStringToBool(acta.alarmaRetroceso),
            'Asiento operdor': convertStringToBool(acta.asientoOperador),
            'Baliza': convertStringToBool(acta.baliza),
            'Bocina': convertStringToBool(acta.bocina),
            'Extintor': convertStringToBool(acta.extintor),
            'Espejos': convertStringToBool(acta.espejos),
            'Focos faeneros delanteros':
                convertStringToBool(acta.focosFaenerosDelanteros),
            'Focos faeneros traseros':
                convertStringToBool(acta.focosFaenerosTraseros),
            'LLave de contacto': convertStringToBool(acta.llaveContacto),
            'Intermitentes delanteros':
                convertStringToBool(acta.intermitentesDelanteros),
            'Intermitentes traseros':
                convertStringToBool(acta.intermitentesTraseros),
            'Palanca freno mano': convertStringToBool(acta.palancaFrenoMano),
            'Pera de volante': convertStringToBool(acta.peraVolante),
            'Arnes de cilindro de gas':
                convertStringToBool(acta.arnesCilindroGas),
            'Tablero instrumentos':
                convertStringToBool(acta.tableroIntrumentos),
          },
          {
            '': [false, false, false],
            'Cilindro desplazador':
                convertStringToBool(acta.cilindroDesplazador),
            'Cilindro direccion': convertStringToBool(acta.cilindroDireccion),
            'Cilindro levante central':
                convertStringToBool(acta.cilindroLevanteCentral),
            'Cilindro inclinacion':
                convertStringToBool(acta.cilindroInclinacion),
            'Cilindro levante laterales':
                convertStringToBool(acta.cilindroLevanteLateral),
            'Flexibles hidraulicas':
                convertStringToBool(acta.flexibleHidraulico),
            'Fuga por conectores y mangueras':
                convertStringToBool(acta.fugaConectores),
          },
          {
            '': [false, false, false],
            'Alternador': convertStringToBool(acta.alternador),
            'Bateria': convertStringToBool(acta.bateria),
            'Chapa de contacto': convertStringToBool(acta.chapaContacto),
            'Sistema electrico': convertStringToBool(acta.sistemaElectrico),
            'Horometro': convertStringToBool(acta.horometro),
            'Motor de partida': convertStringToBool(acta.motorPartida),
            'Palanca comandos': convertStringToBool(acta.palancaComando),
            'Switch de luces': convertStringToBool(acta.switchLuces),
            'Switch de marchas': convertStringToBool(acta.switchMarcha),
          },
          {
            '': [false, false, false],
            'Cadenas': convertStringToBool(acta.cadena),
            'Carro y su respaldo de carga': convertStringToBool(acta.carro),
            'Horquillas y seguros': convertStringToBool(acta.horquilla),
            'Jaula de proteccion': convertStringToBool(acta.jaula),
            'LLantas': convertStringToBool(acta.llantas),
            'Mastil': convertStringToBool(acta.mastil),
            'Pintura': convertStringToBool(acta.pintura),
            'Ruedas': convertStringToBool(acta.rueda),
          },
          {
            '': [false, false, false],
            'Desplazador lateral': convertStringToBool(acta.desplazadorLateral),
            'Direccion': convertStringToBool(acta.direccion),
            'Freno mano': convertStringToBool(acta.frenoMano),
            'Freno pie': convertStringToBool(acta.frenoPie),
            'Inclinacion': convertStringToBool(acta.inclinacion),
            'Levante': convertStringToBool(acta.levante),
            'Motor': convertStringToBool(acta.motor),
            'Nivel aceite hidraulico':
                convertStringToBool(acta.nivelAceiteHidraulico),
            'Nivel aceite motor': convertStringToBool(acta.nivelAceiteMotor),
            'Nivel aceite transmision':
                convertStringToBool(acta.nivelAceiteTransmision),
            'Nivel liquido de freno':
                convertStringToBool(acta.nivelLiquinoFreno),
            'Tapa combustible': convertStringToBool(acta.tapaCombustible),
            'Tapa radiador': convertStringToBool(acta.tapaRadiador),
            'Transmision': convertStringToBool(acta.transmision),
          }
        ]
      };
    } else {
      MapOfValue['ACTA'] = {
        "OPTION_SELECT": {
          'Carro y su respaldo de carga': AuxSelectItem(
              text: "Respaldo",
              select: acta.carga == 1 ? "SI" : "NO",
              tipo: "select",
              options: ["SI", "NO"]),
          'Bateria': AuxSelectItem(
              text: "Observaciones",
              select: acta.bateriaObservaciones!,
              tipo: "text",
              options: []),
          'Serie cargador': AuxSelectItem(
              text: "Serie",
              select: acta.serieCargardorText!,
              tipo: "text",
              options: []),
          'Cargador voltaje y amperaje': AuxSelectItem(
              text: "Voltaje",
              select: acta.cargadorVoltajeInfo! + 'V',
              tipo: "select",
              options: ["48V", "24V"]),
          'Enchufes': AuxSelectItem(
              text: "Tipo enchufe",
              select: acta.enchufeInfo!.split("-")[0] +
                  "A " +
                  "POLO " +
                  acta.enchufeInfo!.split("-")[1],
              tipo: "select",
              options: [
                "16A POLO 4",
                "16A POLO 5",
                "32A POLO 4",
                "32A POLO 5"
              ]),
        },
        "TEXT_CAMP": {
          'Espejos': acta.cantidadEspejos.toString(),
          'Focos faeneros delanteros':
              acta.cantidadFocosFaenerosDelanteros.toString(),
          'Focos faeneros traseros':
              acta.cantidadFocosFaenerosTraseros.toString(),
          'LLave de contacto': acta.cantidadLlaveContacto.toString(),
          'Intermitentes delanteros':
              acta.cantidadIntermitentesDelanteros.toString(),
          'Intermitentes traseros':
              acta.cantidadIntermitentesTraseros.toString(),
          'Ruedas': acta.cantidadRueda.toString(),
        },
        "SELECT_CAMP": [
          {
            '': [false, false, false],
            'Alarma retroceso': convertStringToBool(acta.alarmaRetroceso),
            'Asiento operdor': convertStringToBool(acta.asientoOperador),
            'Baliza': convertStringToBool(acta.baliza),
            'Bocina': convertStringToBool(acta.bocina),
            'Extintor': convertStringToBool(acta.extintor),
            'Espejos': convertStringToBool(acta.espejos),
            'Focos faeneros delanteros':
                convertStringToBool(acta.focosFaenerosDelanteros),
            'Focos faeneros traseros':
                convertStringToBool(acta.focosFaenerosTraseros),
            'LLave de contacto': convertStringToBool(acta.llaveContacto),
            'Intermitentes delanteros':
                convertStringToBool(acta.intermitentesDelanteros),
            'Intermitentes traseros':
                convertStringToBool(acta.intermitentesTraseros),
            'Palanca freno mano': convertStringToBool(acta.palancaFrenoMano),
            'Pera de volante': convertStringToBool(acta.peraVolante),
            'Tablero instrumentos':
                convertStringToBool(acta.tableroIntrumentos),
          },
          {
            '': [false, false, false],
            'Cilindro desplazador':
                convertStringToBool(acta.cilindroDesplazador),
            'Cilindro direccion cadena':
                convertStringToBool(acta.cilindroDireccion),
            'Cilindro levante central':
                convertStringToBool(acta.cilindroLevanteCentral),
            'Cilindro inclinacion':
                convertStringToBool(acta.cilindroInclinacion),
            'Cilindro levante laterales':
                convertStringToBool(acta.cilindroLevanteLateral),
            'Flexibles hidraulicas':
                convertStringToBool(acta.flexibleHidraulico),
            'Fuga por conectores y mangueras':
                convertStringToBool(acta.fugaConectores),
          },
          {
            '': [false, false, false],
            'Bateria': convertStringToBool(acta.bateria),
            'Chapa de contacto': convertStringToBool(acta.chapaContacto),
            'Sistema electrico': convertStringToBool(acta.sistemaElectrico),
            'Horometro': convertStringToBool(acta.horometro),
            'Palanca comandos': convertStringToBool(acta.palancaComando),
            'Switch de luces': convertStringToBool(acta.switchLuces),
            'Switch de marchas': convertStringToBool(acta.switchMarcha),
            'Joystick': convertStringToBool(acta.joystick),
          },
          {
            '': [false, false, false],
            'Cadenas': convertStringToBool(acta.cadena),
            'Carro y su respaldo de carga': convertStringToBool(acta.carro),
            'Horquillas y seguros': convertStringToBool(acta.horquilla),
            'Jaula de proteccion': convertStringToBool(acta.jaula),
            'LLantas': convertStringToBool(acta.llantas),
            'Mastil': convertStringToBool(acta.mastil),
            'Pintura': convertStringToBool(acta.pintura),
            'Ruedas': convertStringToBool(acta.rueda),
          },
          {
            '': [false, false, false],
            'Desplazador lateral': convertStringToBool(acta.desplazadorLateral),
            'Direccion': convertStringToBool(acta.direccion),
            'Freno mano': convertStringToBool(acta.frenoMano),
            'Freno pie': convertStringToBool(acta.frenoPie),
            'Inclinacion': convertStringToBool(acta.inclinacion),
            'Levante': convertStringToBool(acta.levante),
            'Nivel aceite hidraulico':
                convertStringToBool(acta.nivelAceiteHidraulico),
            'Serie cargador': convertStringToBool(acta.serieCargador),
            'Nivel liquido de freno':
                convertStringToBool(acta.nivelLiquinoFreno),
            'Cargador voltaje y amperaje':
                convertStringToBool(acta.cargadorVoltajeInfo),
            'Enchufes': convertStringToBool(acta.enchufe),
          }
        ]
      };
    }
    notifyListeners();
  }

  initMap(bool tipoValue) {
    if (tipoValue) {
      MapOfValue['ACTA'] = {
        "OPTION_SELECT": {
          "Arnes de cilindro de gas": AuxSelectItem(
              text: "Cilindro de gas",
              tipo: "select",
              select: "NO",
              options: ["SI", "NO"]),
          'Carro y su respaldo de carga': AuxSelectItem(
              text: "Respaldo",
              tipo: "select",
              select: "NO",
              options: ["SI", "NO"]),
        },
        "TEXT_CAMP": {
          'Espejos': "",
          'Focos faeneros delanteros': "",
          'Focos faeneros traseros': "",
          'LLave de contacto': "",
          'Intermitentes delanteros': "",
          'Intermitentes traseros': "",
          'Ruedas': "0",
        },
        "SELECT_CAMP": [
          {
            '': [false, false, false],
            'Alarma retroceso': [false, false, false],
            'Asiento operdor': [false, false, false],
            'Baliza': [false, false, false],
            'Bocina': [false, false, false],
            'Extintor': [false, false, false],
            'Espejos': [false, false, false],
            'Focos faeneros delanteros': [false, false, false],
            'Focos faeneros traseros': [false, false, false],
            'LLave de contacto': [false, false, false],
            'Intermitentes delanteros': [false, false, false],
            'Intermitentes traseros': [false, false, false],
            'Palanca freno mano': [false, false, false],
            'Pera de volante': [false, false, false],
            'Arnes de cilindro de gas': [false, false, false],
            'Tablero instrumentos': [false, false, false],
          },
          {
            '': [false, false, false],
            'Cilindro desplazador': [false, false, false],
            'Cilindro direccion': [false, false, false],
            'Cilindro levante central': [false, false, false],
            'Cilindro inclinacion': [false, false, false],
            'Cilindro levante laterales': [false, false, false],
            'Flexibles hidraulicas': [false, false, false],
            'Fuga por conectores y mangueras': [false, false, false],
          },
          {
            '': [false, false, false],
            'Alternador': [false, false, false],
            'Bateria': [false, false, false],
            'Chapa de contacto': [false, false, false],
            'Sistema electrico': [false, false, false],
            'Horometro': [false, false, false],
            'Motor de partida': [false, false, false],
            'Palanca comandos': [false, false, false],
            'Switch de luces': [false, false, false],
            'Switch de marchas': [false, false, false],
          },
          {
            '': [false, false, false],
            'Cadenas': [false, false, false],
            'Carro y su respaldo de carga': [false, false, false],
            'Horquillas y seguros': [false, false, false],
            'Jaula de proteccion': [false, false, false],
            'LLantas': [false, false, false],
            'Mastil': [false, false, false],
            'Pintura': [false, false, false],
            'Ruedas': [false, false, false],
          },
          {
            '': [false, false, false],
            'Desplazador lateral': [false, false, false],
            'Direccion': [false, false, false],
            'Freno mano': [false, false, false],
            'Freno pie': [false, false, false],
            'Inclinacion': [false, false, false],
            'Levante': [false, false, false],
            'Motor': [false, false, false],
            'Nivel aceite hidraulico': [false, false, false],
            'Nivel aceite motor': [false, false, false],
            'Nivel aceite transmision': [false, false, false],
            'Nivel liquido de freno': [false, false, false],
            'Tapa combustible': [false, false, false],
            'Tapa radiador': [false, false, false],
            'Transmision': [false, false, false],
          }
        ]
      };
    } else {
      MapOfValue['ACTA'] = {
        "OPTION_SELECT": {
          'Carro y su respaldo de carga': AuxSelectItem(
              text: "Respaldo",
              select: "NO",
              tipo: "select",
              options: ["SI", "NO"]),
          'Bateria': AuxSelectItem(
              text: "Observaciones", select: "", tipo: "text", options: []),
          'Serie cargador': AuxSelectItem(
              text: "Serie", select: "", tipo: "text", options: []),
          'Cargador voltaje y amperaje': AuxSelectItem(
              text: "Voltaje",
              select: "48V",
              tipo: "select",
              options: ["48V", "24V"]),
          'Enchufes': AuxSelectItem(
              text: "Tipo enchufe",
              select: "16A POLO 4",
              tipo: "select",
              options: [
                "16A POLO 4",
                "16A POLO 5",
                "32A POLO 4",
                "32A POLO 5"
              ]),
        },
        "TEXT_CAMP": {
          'Espejos': "",
          'Focos faeneros delanteros': "",
          'Focos faeneros traseros': "",
          'LLave de contacto': "",
          'Intermitentes delanteros': "",
          'Intermitentes traseros': "",
          'Ruedas': "",
        },
        "SELECT_CAMP": [
          {
            '': [false, false, false],
            'Alarma retroceso': [false, false, false],
            'Asiento operdor': [false, false, false],
            'Baliza': [false, false, false],
            'Bocina': [false, false, false],
            'Extintor': [false, false, false],
            'Espejos': [false, false, false],
            'Focos faeneros delanteros': [false, false, false],
            'Focos faeneros traseros': [false, false, false],
            'LLave de contacto': [false, false, false],
            'Intermitentes delanteros': [false, false, false],
            'Intermitentes traseros': [false, false, false],
            'Palanca freno mano': [false, false, false],
            'Pera de volante': [false, false, false],
            'Tablero instrumentos': [false, false, false],
          },
          {
            '': [false, false, false],
            'Cilindro desplazador': [false, false, false],
            'Cilindro direccion cadena': [false, false, false],
            'Cilindro levante central': [false, false, false],
            'Cilindro inclinacion': [false, false, false],
            'Cilindro levante laterales': [false, false, false],
            'Flexibles hidraulicas': [false, false, false],
            'Fuga por conectores y mangueras': [false, false, false],
          },
          {
            '': [false, false, false],
            'Bateria': [false, false, false],
            'Chapa de contacto': [false, false, false],
            'Sistema electrico': [false, false, false],
            'Horometro': [false, false, false],
            'Palanca comandos': [false, false, false],
            'Switch de luces': [false, false, false],
            'Switch de marchas': [false, false, false],
            'Joystick': [false, false, false],
          },
          {
            '': [false, false, false],
            'Cadenas': [false, false, false],
            'Carro y su respaldo de carga': [false, false, false],
            'Horquillas y seguros': [false, false, false],
            'Jaula de proteccion': [false, false, false],
            'LLantas': [false, false, false],
            'Mastil': [false, false, false],
            'Pintura': [false, false, false],
            'Ruedas': [false, false, false],
          },
          {
            '': [false, false, false],
            'Desplazador lateral': [false, false, false],
            'Direccion': [false, false, false],
            'Freno mano': [false, false, false],
            'Freno pie': [false, false, false],
            'Inclinacion': [false, false, false],
            'Levante': [false, false, false],
            'Nivel aceite hidraulico': [false, false, false],
            'Serie cargador': [false, false, false],
            'Nivel liquido de freno': [false, false, false],
            'Cargador voltaje y amperaje': [false, false, false],
            'Enchufes': [false, false, false],
          }
        ]
      };
    }

    notifyListeners();
  }

  setMastilEquipo(String value) {
    MapOfValue['mastilEquipo'] = value;
    notifyListeners();
  }

  setHorometroActual(String value) {
    MapOfValue['horometroActual'] = value;
    notifyListeners();
  }

  setAlturaLevante(String text) {
    MapOfValue['alturaLevante'] = text;
    notifyListeners();
  }

  setTipo(bool newTipo) {
    MapOfValue['tipo'] = newTipo;
    initMap(newTipo);
    notifyListeners();
  }

  setRut(String newRut) {
    //Formatiarlo automaticamente
    MapOfValue['rut'] = RUTValidator.formatFromText(newRut);
    notifyListeners();
  }

  setName(String newName) {
    MapOfValue['name'] = newName;
    notifyListeners();
  }

  setObv(String newObv) {
    MapOfValue['obv'] = newObv;
    notifyListeners();
  }

  setEquipo(Equipo newEquipoSelect) {
    MapOfValue['equipo'] = newEquipoSelect;
    notifyListeners();
  }

  setId(String newId) {
    MapOfValue['id'] = newId;
    notifyListeners();
  }

  setFieldSpecialBateria(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Bateria'].select = text;
    notifyListeners();
  }

  setFieldSpecialCargadorVoltaje(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Cargador voltaje y amperaje'].select =
        text;
    notifyListeners();
  }

  setFieldSpecialLlave(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['LLave de contacto'].select = text;
    notifyListeners();
  }

  setFieldSpecialFocosT(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Focos faeneros traseros'].select =
        text;
    notifyListeners();
  }

  setFieldSpecialFocosD(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Focos faeneros delanteros'].select =
        text;
    notifyListeners();
  }

  setFieldSpecialEspejos(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Espejos'].select = text;
    notifyListeners();
  }

  setFieldSpecialAlarma(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Alarma retroceso'].select = text;
    notifyListeners();
  }

  setFieldSpecialExtintor(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Extintor'].select = text;
    notifyListeners();
  }

  setFiedlsSpecialEnchufe(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Enchufes'].select = text;
    notifyListeners();
  }

  setFieldSerieCargador(String text) {
    MapOfValue['ACTA']['OPTION_SELECT']['Serie cargador'].select = text;
    notifyListeners();
  }

  setFieldSpecialRespaldoElectrico(String opcion) {
    MapOfValue['ACTA']['OPTION_SELECT']['Carro y su respaldo de carga'].select =
        opcion;
    notifyListeners();
  }

  setFieldSpecialRespaldoEquipo(String opcion) {
    MapOfValue['ACTA']['OPTION_SELECT']['Carro y su respaldo de carga'].select =
        opcion;
    notifyListeners();
  }

  setFieldSpecialArnes(String opcion) {
    MapOfValue['ACTA']['OPTION_SELECT']['Arnes de cilindro de gas'].select =
        opcion;
    notifyListeners();
  }

  setEspejos(String espejos) {
    MapOfValue['ACTA']['TEXT_CAMP']['Espejos'] = espejos;
    notifyListeners();
  }

  setFocosD(String focosD) {
    MapOfValue['ACTA']['TEXT_CAMP']['Focos faeneros delanteros'] = focosD;
    notifyListeners();
  }

  setFocosT(String focosT) {
    MapOfValue['ACTA']['TEXT_CAMP']['Focos faeneros traseros'] = focosT;

    notifyListeners();
  }

  setLlave(String llave) {
    MapOfValue['ACTA']['TEXT_CAMP']['LLave de contacto'] = llave;
    notifyListeners();
  }

  setInterD(String interD) {
    MapOfValue['ACTA']['TEXT_CAMP']['Intermitentes delanteros'] = interD;

    notifyListeners();
  }

  setInterT(String interT) {
    MapOfValue['ACTA']['TEXT_CAMP']['Intermitentes traseros'] = interT;
    notifyListeners();
  }

  setRuedas(String rueda) {
    MapOfValue['ACTA']['TEXT_CAMP']['Ruedas'] = rueda;
    notifyListeners();
  }

  setValue(int position, String key, int boolPosition, bool value) {
    MapOfValue['ACTA']['SELECT_CAMP'][position][key]![boolPosition] = value;
    notifyListeners();
  }

  changeAllColumn(int position, int columnInt, bool value) {
    for (var i = 0;
        i < MapOfValue['ACTA']['SELECT_CAMP'][position].length;
        i++) {
      var keyAux =
          MapOfValue['ACTA']['SELECT_CAMP'][position].keys.elementAt(i);
      if (columnInt == 0) {
        MapOfValue['ACTA']['SELECT_CAMP'][position]
            [keyAux] = [value, false, false];
      }
      if (columnInt == 1) {
        MapOfValue['ACTA']['SELECT_CAMP'][position]
            [keyAux] = [false, value, false];
      }
      if (columnInt == 2) {
        MapOfValue['ACTA']['SELECT_CAMP'][position]
            [keyAux] = [false, false, value];
      }
    }
    notifyListeners();
  }

  List<bool> convertStringToBool(String? param) {
    if (param == null) {
      return [false, false, false];
    }
    if (param == 'bueno') {
      return [true, false, false];
    } else if (param == 'regular') {
      return [false, true, false];
    } else {
      return [false, false, true];
    }
  }
}
