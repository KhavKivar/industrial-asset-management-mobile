import 'package:app_licman/model/inspeccion.dart';

List<bool> convertStrinToBool(String? param) {
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

Map<String, int> getTextCamp(inspeccion) {
  return {
    'Espejos': inspeccion.cantidadEspejos!,
    'Focos faeneros delanteros': inspeccion.cantidadFocosFaenerosDelanteros!,
    'Focos faeneros traseros': inspeccion.cantidadFocosFaenerosTraseros!,
    'LLave de contacto': inspeccion.cantidadLlaveContacto!,
    'Intermitentes delanteros': inspeccion.cantidadIntermitentesDelanteros!,
    'Intermitentes traseros': inspeccion.cantidadIntermitentesTraseros!,
    'Ruedas': inspeccion.cantidadRueda!,
  };
}

Map<String, List<String>> getSelectCamp(inspeccion, tipo) {
  if (tipo == 'acta_equipo') {
    return {
      "Carro y su respaldo de carga": [
        "Respaldo de carga: ",
        inspeccion.carga! == 1 ? "Si" : "No"
      ],
      "Arnes de cilindro de gas": [
        "Cilindro de gas: ",
        inspeccion.cilindroDeGas == 1 ? "Si" : "No"
      ],
    };
  } else {
    return {
      "Carro y su respaldo de carga": [
        "Respaldo de carga: ",
        inspeccion.carga! == 1 ? "Si" : "No"
      ],
      "Serie cargador": ["Serie: ", inspeccion.serieCargardorText!],
      "Bateria": ["Observaciones: ", inspeccion.bateriaObservaciones!],
      "Cargador voltaje y amperaje": [
        "Voltaje: ",
        inspeccion.cargadorVoltajeInfo! + "V"
      ],
      "Enchufes": [
        "Tipo enchufe: ",
        inspeccion.enchufeInfo!.split("-")[0] +
            "A " +
            "POLO " +
            inspeccion.enchufeInfo!.split("-")[1]
      ],
    };
  }
}

Map<String, Map<dynamic, dynamic>> getCheckBoxCamp(inspeccion, tipo) {
  if (tipo == "acta_equipo") {
    return {
      "ACCESORIOS": {
        '': [false, false, false],
        'Alarma retroceso': convertStrinToBool(inspeccion.alarmaRetroceso),
        'Asiento operdor': convertStrinToBool(inspeccion.asientoOperador),
        'Baliza': convertStrinToBool(inspeccion.baliza),
        'Bocina': convertStrinToBool(inspeccion.bocina),
        'Extintor': convertStrinToBool(inspeccion.extintor),
        'Espejos': convertStrinToBool(inspeccion.espejos),
        'Focos faeneros delanteros':
            convertStrinToBool(inspeccion.focosFaenerosDelanteros),
        "Focos faeneros traseros":
            convertStrinToBool(inspeccion.focosFaenerosTraseros),
        "LLave de contacto": convertStrinToBool(inspeccion.llaveContacto),
        "Intermitentes delanteros":
            convertStrinToBool(inspeccion.intermitentesDelanteros),
        "Intermitentes traseros":
            convertStrinToBool(inspeccion.intermitentesTraseros),
        "Palanca freno mano": convertStrinToBool(inspeccion.palancaFrenoMano),
        "Pera de volante": convertStrinToBool(inspeccion.peraVolante),
        "Arnes de cilindro de gas":
            convertStrinToBool(inspeccion.arnesCilindroGas),
        "Tablero instrumentos":
            convertStrinToBool(inspeccion.tableroIntrumentos),
      },
      "SISTEMA HIDRAULICO": {
        '': [false, false, false],
        "Cilindro desplazador":
            convertStrinToBool(inspeccion.cilindroDesplazador),
        "Cilindro direccion": convertStrinToBool(inspeccion.cilindroDireccion),
        "Cilindro levante central":
            convertStrinToBool(inspeccion.cilindroLevanteCentral),
        "Cilindro inclinacion":
            convertStrinToBool(inspeccion.cilindroInclinacion),
        "Cilindro levante laterales":
            convertStrinToBool(inspeccion.cilindroLevanteLateral),
        "Flexibles hidraulicas":
            convertStrinToBool(inspeccion.flexibleHidraulico),
        "Fuga por conectores y mangueras":
            convertStrinToBool(inspeccion.fugaConectores),
      },
      "SISTEMA ELECTRICO": {
        '': [false, false, false],
        "Alternador": convertStrinToBool(inspeccion.alternador),
        "Bateria": convertStrinToBool(inspeccion.bateria),
        "Chapa de contacto": convertStrinToBool(inspeccion.chapaContacto),
        "Sistema electrico": convertStrinToBool(inspeccion.sistemaElectrico),
        "Horometro": convertStrinToBool(inspeccion.horometro),
        "Motor de partida": convertStrinToBool(inspeccion.motorPartida),
        "Palanca comandos": convertStrinToBool(inspeccion.palancaComando),
        "Switch de luces": convertStrinToBool(inspeccion.switchLuces),
        "Switch de marchas": convertStrinToBool(inspeccion.switchMarcha),
      },
      "CHASIS ESTRUCTURA": {
        '': [false, false, false],
        "Cadenas": convertStrinToBool(inspeccion.cadena),
        "Carro y su respaldo de carga": convertStrinToBool(inspeccion.carro),
        "Horquillas y seguros": convertStrinToBool(inspeccion.horquilla),
        "Jaula de proteccion": convertStrinToBool(inspeccion.jaula),
        "LLantas": convertStrinToBool(inspeccion.llantas),
        "Mastil": convertStrinToBool(inspeccion.mastil),
        "Pintura": convertStrinToBool(inspeccion.pintura),
        "Ruedas": convertStrinToBool(inspeccion.rueda),
      },
      "PRUEBAS DE OPERACION": {
        '': [false, false, false],
        "Desplazador lateral":
            convertStrinToBool(inspeccion.desplazadorLateral),
        "Direccion": convertStrinToBool(inspeccion.direccion),
        "Freno mano": convertStrinToBool(inspeccion.frenoMano),
        "Freno pie": convertStrinToBool(inspeccion.frenoPie),
        "Inclinacion": convertStrinToBool(inspeccion.inclinacion),
        "Levante": convertStrinToBool(inspeccion.levante),
        "Motor": convertStrinToBool(inspeccion.motor),
        "Nivel aceite hidraulico":
            convertStrinToBool(inspeccion.nivelAceiteHidraulico),
        "Nivel aceite motor": convertStrinToBool(inspeccion.nivelAceiteMotor),
        "Nivel aceite transmision":
            convertStrinToBool(inspeccion.nivelAceiteTransmision),
        "Nivel liquido de freno":
            convertStrinToBool(inspeccion.nivelLiquinoFreno),
        "Tapa combustible": convertStrinToBool(inspeccion.tapaCombustible),
        "Tapa radiador": convertStrinToBool(inspeccion.tapaRadiador),
        "Transmision": convertStrinToBool(inspeccion.transmision),
      },
      "FIRMA Y OBSERVACIONES": {}
    };
  } else {
    return {
      "ACCESORIOS": {
        '': [false, false, false],
        'Alarma retroceso': convertStrinToBool(inspeccion.alarmaRetroceso),
        'Asiento operdor': convertStrinToBool(inspeccion.asientoOperador),
        'Baliza': convertStrinToBool(inspeccion.baliza),
        'Bocina': convertStrinToBool(inspeccion.bocina),
        'Extintor': convertStrinToBool(inspeccion.extintor),
        'Espejos': convertStrinToBool(inspeccion.espejos),
        'Focos faeneros delanteros':
            convertStrinToBool(inspeccion.focosFaenerosDelanteros),
        "Focos faeneros traseros":
            convertStrinToBool(inspeccion.focosFaenerosTraseros),
        "LLave de contacto": convertStrinToBool(inspeccion.llaveContacto),
        "Intermitentes delanteros":
            convertStrinToBool(inspeccion.intermitentesDelanteros),
        "Intermitentes traseros":
            convertStrinToBool(inspeccion.intermitentesTraseros),
        "Palanca freno mano": convertStrinToBool(inspeccion.palancaFrenoMano),
        "Pera de volante": convertStrinToBool(inspeccion.peraVolante),
        "Tablero instrumentos":
            convertStrinToBool(inspeccion.tableroIntrumentos),
      },
      "SISTEMA HIDRAULICO": {
        '': [false, false, false],
        "Cilindro desplazador":
            convertStrinToBool(inspeccion.cilindroDesplazador),
        "Cilindro direccion cadena":
            convertStrinToBool(inspeccion.cilindroDireccion),
        "Cilindro levante central":
            convertStrinToBool(inspeccion.cilindroLevanteCentral),
        "Cilindro inclinacion":
            convertStrinToBool(inspeccion.cilindroInclinacion),
        "Cilindro levante laterales":
            convertStrinToBool(inspeccion.cilindroLevanteLateral),
        "Flexibles hidraulicas":
            convertStrinToBool(inspeccion.flexibleHidraulico),
        "Fuga por conectores y mangueras":
            convertStrinToBool(inspeccion.fugaConectores),
      },
      "SISTEMA ELECTRICO": {
        '': [false, false, false],
        "Bateria": convertStrinToBool(inspeccion.bateria),
        "Chapa de contacto": convertStrinToBool(inspeccion.chapaContacto),
        "Sistema electrico": convertStrinToBool(inspeccion.sistemaElectrico),
        "Horometro": convertStrinToBool(inspeccion.horometro),
        "Palanca comandos": convertStrinToBool(inspeccion.palancaComando),
        "Switch de luces": convertStrinToBool(inspeccion.switchLuces),
        "Switch de marchas": convertStrinToBool(inspeccion.switchMarcha),
        "Joystick": convertStrinToBool(inspeccion.joystick),
      },
      "CHASIS ESTRUCTURA": {
        '': [false, false, false],
        "Cadenas": convertStrinToBool(inspeccion.cadena),
        "Carro y su respaldo de carga": convertStrinToBool(inspeccion.carro),
        "Horquillas y seguros": convertStrinToBool(inspeccion.horquilla),
        "Jaula de proteccion": convertStrinToBool(inspeccion.jaula),
        "LLantas": convertStrinToBool(inspeccion.llantas),
        "Mastil": convertStrinToBool(inspeccion.mastil),
        "Pintura": convertStrinToBool(inspeccion.pintura),
        "Ruedas": convertStrinToBool(inspeccion.rueda),
      },
      "PRUEBAS DE OPERACION": {
        '': [false, false, false],
        "Desplazador lateral":
            convertStrinToBool(inspeccion.desplazadorLateral),
        "Direccion": convertStrinToBool(inspeccion.direccion),
        "Freno mano": convertStrinToBool(inspeccion.frenoMano),
        "Freno pie": convertStrinToBool(inspeccion.frenoPie),
        "Inclinacion": convertStrinToBool(inspeccion.inclinacion),
        "Levante": convertStrinToBool(inspeccion.levante),
        "Nivel aceite hidraulico":
            convertStrinToBool(inspeccion.nivelAceiteHidraulico),
        "Serie cargador": convertStrinToBool(inspeccion.serieCargador),
        "Nivel liquido de freno":
            convertStrinToBool(inspeccion.nivelLiquinoFreno),
        "Cargador voltaje y amperaje":
            convertStrinToBool(inspeccion.cargadorVoltaje),
        "Enchufes": convertStrinToBool(inspeccion.enchufe),
      },
      "FIRMA Y OBSERVACIONES": {}
    };
  }
}
