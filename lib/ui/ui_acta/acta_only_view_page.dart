import 'dart:typed_data';

import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/inspeccion.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../main.dart';
import '../tabla_actas/all_actas_page.dart';
import '../ui_creacion_acta/acta_page_view.dart';

class ActaOnlyView extends StatefulWidget {
  const ActaOnlyView({Key? key, required this.inspeccion, this.data}) : super(key: key);
  final Inspeccion inspeccion;
  final Uint8List? data;
  @override
  _ActaOnlyViewState createState() => _ActaOnlyViewState();
}

class _ActaOnlyViewState extends State<ActaOnlyView> {
  bool _value = false;

  final PageController controller = PageController();
  double page = 0.0;

  void _listenScroll() {
    setState(() {
      page = controller.page!;
    });
  }


  late final controller_map;
  var itemsFromTitle;
  late final newFieldsMap;
  late final itemSpecial;


  List<bool> convertStrinToBool(String? param) {
    if(param == null){
      return [false, false, false];
    }
    if (param == 'bueno') {
      return [true, false, false];
    } else if (param == 'regular') {
      return [false, true, false];
    }else{
      return [false, false, true];
    }

  }

  @override
  void initState() {
    super.initState();

    itemSpecial = {
      'Espejos': widget.inspeccion.cantidadEspejos!,
      'Focos faeneros delanteros':
          widget.inspeccion.cantidadFocosFaenerosDelanteros!,
      'Focos faeneros traseros':
          widget.inspeccion.cantidadFocosFaenerosTraseros!,
      'LLave de contacto': widget.inspeccion.cantidadLlaveContacto!,
      'Intermitentes delanteros':
          widget.inspeccion.cantidadIntermitentesDelanteros!,
      'Intermitentes traseros':
          widget.inspeccion.cantidadIntermitentesTraseros!,
      'Ruedas': widget.inspeccion.cantidadRueda!,
    };

    if (widget.inspeccion.tipo == "acta_equipo") {
      newFieldsMap = {
        "Carro y su respaldo de carga": [
          "Respaldo de carga: ",
          widget.inspeccion.carga! == 1 ? "Si" : "No"
        ],
        "Arnes de cilindro de gas": [
          "Cilindro de gas: ",
          widget.inspeccion.cilindroDeGas == 1 ? "Si" : "No"
        ],
      };

      itemsFromTitle = {
        "ACCESORIOS": {
          '': [false, false, false],
          'Alarma retroceso':
              convertStrinToBool(widget.inspeccion.alarmaRetroceso),
          'Asiento operdor':
              convertStrinToBool(widget.inspeccion.asientoOperador),
          'Baliza': convertStrinToBool(widget.inspeccion.baliza),
          'Bocina': convertStrinToBool(widget.inspeccion.bocina),
          'Extintor': convertStrinToBool(widget.inspeccion.extintor),
          'Espejos': convertStrinToBool(widget.inspeccion.espejos),
          'Focos faeneros delanteros':
              convertStrinToBool(widget.inspeccion.focosFaenerosDelanteros),
          "Focos faeneros traseros":
              convertStrinToBool(widget.inspeccion.focosFaenerosTraseros),
          "LLave de contacto":
              convertStrinToBool(widget.inspeccion.llaveContacto),
          "Intermitentes delanteros":
              convertStrinToBool(widget.inspeccion.intermitentesDelanteros),
          "Intermitentes traseros":
              convertStrinToBool(widget.inspeccion.intermitentesTraseros),
          "Palanca freno mano":
              convertStrinToBool(widget.inspeccion.palancaFrenoMano),
          "Pera de volante": convertStrinToBool(widget.inspeccion.peraVolante),
          "Arnes de cilindro de gas":
              convertStrinToBool(widget.inspeccion.arnesCilindroGas),
          "Tablero instrumentos":
              convertStrinToBool(widget.inspeccion.tableroIntrumentos),
        },
        "SISTEMA HIDRAULICO": {
          '': [false, false, false],
          "Cilindro desplazador":
              convertStrinToBool(widget.inspeccion.cilindroDesplazador),
          "Cilindro direccion":
              convertStrinToBool(widget.inspeccion.cilindroDireccion),
          "Cilindro levante central":
              convertStrinToBool(widget.inspeccion.cilindroLevanteCentral),
          "Cilindro inclinacion":
              convertStrinToBool(widget.inspeccion.cilindroInclinacion),
          "Cilindro levante laterales":
              convertStrinToBool(widget.inspeccion.cilindroLevanteLateral),
          "Flexibles hidraulicas":
              convertStrinToBool(widget.inspeccion.flexibleHidraulico),
          "Fuga por conectores y mangueras":
              convertStrinToBool(widget.inspeccion.fugaConectores),
        },
        "SISTEMA ELECTRICO": {
          '': [false, false, false],
          "Alternador": convertStrinToBool(widget.inspeccion.alternador),
          "Bateria": convertStrinToBool(widget.inspeccion.bateria),
          "Chapa de contacto":
              convertStrinToBool(widget.inspeccion.chapaContacto),
          "Sistema electrico":
              convertStrinToBool(widget.inspeccion.sistemaElectrico),
          "Horometro": convertStrinToBool(widget.inspeccion.horometro),
          "Motor de partida":
              convertStrinToBool(widget.inspeccion.motorPartida),
          "Palanca comandos":
              convertStrinToBool(widget.inspeccion.palancaComando),
          "Switch de luces": convertStrinToBool(widget.inspeccion.switchLuces),
          "Switch de marchas":
              convertStrinToBool(widget.inspeccion.switchMarcha),
        },
        "CHASIS ESTRUCTURA": {
          '': [false, false, false],
          "Cadenas": convertStrinToBool(widget.inspeccion.cadena),
          "Carro y su respaldo de carga":
              convertStrinToBool(widget.inspeccion.carro),
          "Horquillas y seguros":
              convertStrinToBool(widget.inspeccion.horquilla),
          "Jaula de proteccion": convertStrinToBool(widget.inspeccion.jaula),
          "LLantas": convertStrinToBool(widget.inspeccion.llantas),
          "Mastil": convertStrinToBool(widget.inspeccion.mastil),
          "Pintura": convertStrinToBool(widget.inspeccion.pintura),
          "Ruedas": convertStrinToBool(widget.inspeccion.rueda),
        },
        "PRUEBAS DE OPERACION": {
          '': [false, false, false],
          "Desplazador lateral":
              convertStrinToBool(widget.inspeccion.desplazadorLateral),
          "Direccion": convertStrinToBool(widget.inspeccion.direccion),
          "Freno mano": convertStrinToBool(widget.inspeccion.frenoMano),
          "Freno pie": convertStrinToBool(widget.inspeccion.frenoPie),
          "Inclinacion": convertStrinToBool(widget.inspeccion.inclinacion),
          "Levante": convertStrinToBool(widget.inspeccion.levante),
          "Motor": convertStrinToBool(widget.inspeccion.motor),
          "Nivel aceite hidraulico":
              convertStrinToBool(widget.inspeccion.nivelAceiteHidraulico),
          "Nivel aceite motor":
              convertStrinToBool(widget.inspeccion.nivelAceiteMotor),
          "Nivel aceite transmision":
              convertStrinToBool(widget.inspeccion.nivelAceiteTransmision),
          "Nivel liquido de freno":
              convertStrinToBool(widget.inspeccion.nivelLiquinoFreno),
          "Tapa combustible":
              convertStrinToBool(widget.inspeccion.tapaCombustible),
          "Tapa radiador": convertStrinToBool(widget.inspeccion.tapaRadiador),
          "Transmision": convertStrinToBool(widget.inspeccion.transmision),
        },
        "FIRMA Y OBSERVACIONES": {}
      };
    } else {
      newFieldsMap = {
        "Carro y su respaldo de carga": [
          "Respaldo de carga: ",
          widget.inspeccion.carga! == 1 ? "Si" : "No"
        ],
        "Serie cargador": ["Serie: ", widget.inspeccion.serieCargardorText!],
        "Bateria": ["Observaciones: ", widget.inspeccion.bateriaObservaciones!],
        "Cargador voltaje y amperaje": [
          "Voltaje: ",
          widget.inspeccion.cargadorVoltajeInfo! + "V"
        ],
        "Enchufes": [
          "Tipo enchufe: ",
          widget.inspeccion.enchufeInfo!.split("-")[0] +
              "A " +
              "POLO " +
              widget.inspeccion.enchufeInfo!.split("-")[1]
        ],
      };

      itemsFromTitle = {
        "ACCESORIOS": {
          '': [false, false, false],
          'Alarma retroceso':
              convertStrinToBool(widget.inspeccion.alarmaRetroceso),
          'Asiento operdor':
              convertStrinToBool(widget.inspeccion.asientoOperador),
          'Baliza': convertStrinToBool(widget.inspeccion.baliza),
          'Bocina': convertStrinToBool(widget.inspeccion.bocina),
          'Extintor': convertStrinToBool(widget.inspeccion.extintor),
          'Espejos': convertStrinToBool(widget.inspeccion.espejos),
          'Focos faeneros delanteros':
              convertStrinToBool(widget.inspeccion.focosFaenerosDelanteros),
          "Focos faeneros traseros":
              convertStrinToBool(widget.inspeccion.focosFaenerosTraseros),
          "LLave de contacto":
              convertStrinToBool(widget.inspeccion.llaveContacto),
          "Intermitentes delanteros":
              convertStrinToBool(widget.inspeccion.intermitentesDelanteros),
          "Intermitentes traseros":
              convertStrinToBool(widget.inspeccion.intermitentesTraseros),
          "Palanca freno mano":
              convertStrinToBool(widget.inspeccion.palancaFrenoMano),
          "Pera de volante": convertStrinToBool(widget.inspeccion.peraVolante),
          "Tablero instrumentos":
              convertStrinToBool(widget.inspeccion.tableroIntrumentos),
        },
        "SISTEMA HIDRAULICO": {
          '': [false, false, false],
          "Cilindro desplazador":
              convertStrinToBool(widget.inspeccion.cilindroDesplazador),
          "Cilindro direccion cadena":
              convertStrinToBool(widget.inspeccion.cilindroDireccion),
          "Cilindro levante central":
              convertStrinToBool(widget.inspeccion.cilindroLevanteCentral),
          "Cilindro inclinacion":
              convertStrinToBool(widget.inspeccion.cilindroInclinacion),
          "Cilindro levante laterales":
              convertStrinToBool(widget.inspeccion.cilindroLevanteLateral),
          "Flexibles hidraulicas":
              convertStrinToBool(widget.inspeccion.flexibleHidraulico),
          "Fuga por conectores y mangueras":
              convertStrinToBool(widget.inspeccion.fugaConectores),
        },
        "SISTEMA ELECTRICO": {
          '': [false, false, false],
          "Bateria": convertStrinToBool(widget.inspeccion.bateria),
          "Chapa de contacto":
              convertStrinToBool(widget.inspeccion.chapaContacto),
          "Sistema electrico":
              convertStrinToBool(widget.inspeccion.sistemaElectrico),
          "Horometro": convertStrinToBool(widget.inspeccion.horometro),
          "Palanca comandos":
              convertStrinToBool(widget.inspeccion.palancaComando),
          "Switch de luces": convertStrinToBool(widget.inspeccion.switchLuces),
          "Switch de marchas":
              convertStrinToBool(widget.inspeccion.switchMarcha),
          "Joystick": convertStrinToBool(widget.inspeccion.joystick),
        },
        "CHASIS ESTRUCTURA": {
          '': [false, false, false],
          "Cadenas": convertStrinToBool(widget.inspeccion.cadena),
          "Carro y su respaldo de carga":
              convertStrinToBool(widget.inspeccion.carro),
          "Horquillas y seguros":
              convertStrinToBool(widget.inspeccion.horquilla),
          "Jaula de proteccion": convertStrinToBool(widget.inspeccion.jaula),
          "LLantas": convertStrinToBool(widget.inspeccion.llantas),
          "Mastil": convertStrinToBool(widget.inspeccion.mastil),
          "Pintura": convertStrinToBool(widget.inspeccion.pintura),
          "Ruedas": convertStrinToBool(widget.inspeccion.rueda),
        },
        "PRUEBAS DE OPERACION": {
          '': [false, false, false],
          "Desplazador lateral":
              convertStrinToBool(widget.inspeccion.desplazadorLateral),
          "Direccion": convertStrinToBool(widget.inspeccion.direccion),
          "Freno mano": convertStrinToBool(widget.inspeccion.frenoMano),
          "Freno pie": convertStrinToBool(widget.inspeccion.frenoPie),
          "Inclinacion": convertStrinToBool(widget.inspeccion.inclinacion),
          "Levante": convertStrinToBool(widget.inspeccion.levante),
          "Nivel aceite hidraulico":
              convertStrinToBool(widget.inspeccion.nivelAceiteHidraulico),
          "Serie cargador":
              convertStrinToBool(widget.inspeccion.serieCargador),
          "Nivel liquido de freno":
              convertStrinToBool(widget.inspeccion.nivelLiquinoFreno),
          "Cargador voltaje y amperaje":
              convertStrinToBool(widget.inspeccion.cargadorVoltaje),
          "Enchufes": convertStrinToBool(widget.inspeccion.enchufe),
        },
        "FIRMA Y OBSERVACIONES": {}
      };
    }
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller.addListener(_listenScroll);

  }
  @override
  void dispose() {
    super.dispose();
  }
  List<String> itemsTitle = [
    "ACCESORIOS",
    "SISTEMA HIDRAULICO",
    "SISTEMA ELECTRICO",
    "CHASIS ESTRUCTURA",
    "PRUEBAS DE OPERACION",
    "FIRMA Y OBSERVACIONES"
  ];
  String dropdownValue = 'ACCESORIOS';
  Map<String, IconData> itemsIcons = {
    "ACCESORIOS": Icons.assignment,
    "SISTEMA HIDRAULICO": Icons.biotech,
    "SISTEMA ELECTRICO": Icons.electrical_services,
    "CHASIS ESTRUCTURA": Icons.directions_car,
    "PRUEBAS DE OPERACION": Icons.speed,
    "FIRMA Y OBSERVACIONES": Icons.edit,
  };

  Map<String, int> itemsPageView = {
    "ACCESORIOS": 0,
    "SISTEMA HIDRAULICO": 1,
    "SISTEMA ELECTRICO": 2,
    "CHASIS ESTRUCTURA": 3,
    "PRUEBAS DE OPERACION": 4,
    "FIRMA Y OBSERVACIONES": 5
  };

  Map<int, String> reverseList = {
    0 :"ACCESORIOS",
    1 : "SISTEMA HIDRAULICO",
    2:"SISTEMA ELECTRICO",
    3:"CHASIS ESTRUCTURA",
    4:"PRUEBAS DE OPERACION",
   5:"FIRMA Y OBSERVACIONES"
  };

  final double fontSizeTextHeader = 18;
  final double fontSizeTextRow = 19;
  String selectPage = "ACCESORIOS";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    dropdownValue = reverseList[page.round()]!;
    selectPage =  reverseList[page.round()]!;
    return Scaffold(
        body: Shortcuts(
          manager: LoggingShortcutManager(),
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.escape): const closePageIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowRight): const nextPageIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowLeft): const previousPageIntent(),
          },
          child: Actions(
            dispatcher: LoggingActionDispatcher(),
            actions: {
              closePageIntent:closePageAction(context),
              nextPageIntent: nextPageAction(controller),
              previousPageIntent: previousPageAction(controller),

            },
            child: Focus(
              autofocus: true,
              child: SafeArea(
                child: itemsFromTitle == null
                    ? Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("Loading"),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: dark,

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: dark,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          size: 30,
                                          color: Colors.white,
                                        )),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: dropdownValue,
                                          icon: const Icon(Icons.arrow_downward,color: Colors.white,),
                                          elevation: 8,
                                          underline: Container(
                                            height: 0,
                                            color: Colors.blueAccent,
                                          ),
                                          style: const TextStyle(color: Colors.white,fontSize: 23),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValue = newValue!;
                                              setState(() {
                                                controller.animateToPage(itemsPageView[newValue]!,
                                                    duration: Duration(milliseconds: 400),
                                                    curve: Curves.easeInOut);
                                                selectPage=newValue;
                                              });
                                            });
                                          },
                                          items: itemsTitle
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  Icon(itemsIcons[value],color: Colors.white,size: 30,),
                                                  const SizedBox(width: 10,),
                                                  Text(value),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: PageView.builder(

                                itemCount: itemsFromTitle.length,
                                controller: controller,
                                itemBuilder: (context, position) {
                                  return Column(
                                    children: [
                                      selectPage == "FIRMA Y OBSERVACIONES"
                                          ? Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 15,vertical: 10),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: dark,
                                                        width: 1.5,
                                                      ),
                                                      color: Colors.white),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 30,
                                                        ),
                                                        widget.data == null ?  SizedBox(
                                                          height: 200,
                                                          child: Stack(
                                                            children: [
                                                              const Center(child: CircularProgressIndicator()),
                                                              Center(
                                                                child: FadeInImage
                                                                    .memoryNetwork(
                                                                  placeholder:
                                                                      kTransparentImage,
                                                                  image: widget
                                                                      .inspeccion.firmaUrl!,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ) :
                                                       SizedBox(
                                                          height: 200,
                                                          child:  Image.memory(
                                                              widget.data!)
                                                          ),


                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        RowWidgetObvAndDetails(
                                                          StringFinal:
                                                              widget.inspeccion.rut!,
                                                          StringInitial:
                                                              'Rut Cliente',
                                                        ),
                                                        RowWidgetObvAndDetails(
                                                          StringFinal: widget
                                                              .inspeccion.nombre!,
                                                          StringInitial:
                                                              'Nombre Cliente',
                                                        ),
                                                        RowWidgetObvAndDetails(
                                                          StringFinal: widget
                                                              .inspeccion
                                                              .observacion!,
                                                          StringInitial:
                                                              'Observaciones',
                                                        ),
                                                        RowWidgetObvAndDetails(
                                                          StringFinal: widget
                                                              .inspeccion
                                                              .alturaLevante!,
                                                          StringInitial:
                                                              'Altura de levante',
                                                        ),
                                                        RowWidgetObvAndDetails(
                                                          StringFinal: widget.inspeccion.mastilEquipo!,
                                                          StringInitial:
                                                          'Mastil',
                                                        ),
                                                        RowWidgetObvAndDetails(
                                                          StringFinal: widget
                                                              .inspeccion
                                                              .horometroActual
                                                              .toString(),
                                                          StringInitial:
                                                              'Horometro registrado',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Flexible(

                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: dark,
                                                        width: 1.5,
                                                      ),
                                                      color: Colors.white),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        itemsFromTitle[selectPage]
                                                            .length,
                                                    itemBuilder: (BuildContext context,
                                                        int index) {
                                                      String key =
                                                          itemsFromTitle[selectPage]
                                                              .keys
                                                              .elementAt(index);
                                                      return Container(
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                            border: index==0 ? Border(): Border(top:
                                                            BorderSide(width: 1.5,color: dark),
                                                            )
                                                          ),
                                                          child: SizedBox(
                                                              child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Align(
                                                                    alignment:Alignment.topLeft,
                                                                    child: FittedBox(
                                                                      fit:BoxFit.scaleDown,
                                                                      child: Row(
                                                                children: [
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      Text(
                                                                        key,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                fontSizeTextRow),
                                                                      ),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                                    ),
                                                                  )),
                                                              Row(
                                                                children: [
                                                                  if (newFieldsMap[
                                                                          key] !=
                                                                      null)
                                                                    Container(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                                  .only(
                                                                              right:
                                                                                  15.0),
                                                                      child: Text(newFieldsMap[
                                                                                  key]
                                                                              [0] +
                                                                          newFieldsMap[
                                                                                  key]
                                                                              [1]),
                                                                    )),
                                                                  if (itemSpecial[
                                                                          key] !=
                                                                      null)
                                                                    Container(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                                  .only(
                                                                              right:
                                                                                  15.0),
                                                                      child: Text(
                                                                          "Cantidad: ${itemSpecial[key]}"),
                                                                    )),
                                                                  index == 0
                                                                      ? Padding(
                                                                          padding: const EdgeInsets
                                                                                  .symmetric(
                                                                              vertical:
                                                                                  10,
                                                                              horizontal:
                                                                                  5),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "Bueno",
                                                                                  style:
                                                                                      TextStyle(fontSize: 18),
                                                                                ),
                                                                                Text(
                                                                                  "Regular",
                                                                                  style:
                                                                                      TextStyle(fontSize: 18),
                                                                                ),
                                                                                Text(
                                                                                  "Malo",
                                                                                  style:
                                                                                      TextStyle(fontSize: 18),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : SizedBox(
                                                                          width: 200,
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .spaceBetween,
                                                                            children: [
                                                                              Checkbox(
                                                                                value:
                                                                                    itemsFromTitle[selectPage][key]![0],
                                                                                onChanged:
                                                                                    (bool? value) {},
                                                                              ),
                                                                              Checkbox(
                                                                                value:
                                                                                    itemsFromTitle[selectPage][key]![1],
                                                                                onChanged:
                                                                                    (bool? value) {},
                                                                              ),
                                                                              Checkbox(
                                                                                value:
                                                                                    itemsFromTitle[selectPage][key]![2],
                                                                                onChanged:
                                                                                    (bool? value) {},
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                ],
                                                              )
                                                            ],
                                                          )));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ));
  }
}

/**
 *
 *
 *
 * */
class RowWidgetObvAndDetails extends StatelessWidget {
  const RowWidgetObvAndDetails({
    Key? key,
    required this.StringFinal,
    required this.StringInitial,
  }) : super(key: key);
  final String StringInitial;
  final String StringFinal;
  final double fontSizeRow = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 1.5, color: dark))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(

          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringInitial,
              style: TextStyle(fontSize: fontSizeRow),
            ),
            const SizedBox(width: 50,),
            Expanded(child: Align(
                alignment: Alignment.topRight,
                child: Text(StringFinal, style: TextStyle(fontSize: fontSizeRow))))
          ],
        ),
      ),
    );
  }
}
