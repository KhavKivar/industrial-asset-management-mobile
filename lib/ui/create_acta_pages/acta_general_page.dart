import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/state/acta_state.dart';
import 'package:app_licman/model/state/app_state.dart';
import 'package:app_licman/widget/details_equipo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'acta_inspeccion_mobile.dart';
import 'acta_inspeccion_page.dart';

class ActaGeneral extends StatefulWidget {
  const ActaGeneral({Key? key, this.device}) : super(key: key);
  final device;

  @override
  _ActaGeneralState createState() => _ActaGeneralState();
}

class _ActaGeneralState extends State<ActaGeneral>
    with AutomaticKeepAliveClientMixin {
  late final equiposStateProvider;
  TextEditingController? _typeAheadController;
  TextEditingController? altureLevanteController;
  TextEditingController? horometroActualController;

  Equipo? equipoSelect = null;
  String? dropdownValue = null;

  @override
  void initState() {
    super.initState();
    equiposStateProvider = Provider.of<AppState>(context, listen: false);
    _typeAheadController = TextEditingController(
        text: Provider.of<ActaState>(context, listen: false).MapOfValue['id']);

    altureLevanteController = TextEditingController(
        text: Provider.of<ActaState>(context, listen: false)
            .MapOfValue['alturaLevante']);
    horometroActualController = TextEditingController(
        text: Provider.of<ActaState>(context, listen: false)
            .MapOfValue['horometroActual']);
    dropdownValue = Provider.of<ActaState>(context, listen: false)
        .MapOfValue['mastilEquipo'];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    equipoSelect = Provider.of<ActaState>(context).MapOfValue['equipo'];
  }

  @override
  void dispose() {
    _typeAheadController?.dispose();
    super.dispose();
  }

  late bool tipo;
  //Mobile parameters
  final double fontSizeTextRow = 22;
  final double fontSizeTypeAhead = 15;
  final double fontSizeTypeSuggest = 20;
  final double fontSizeTypeAheadIcon = 25;
  final double fontSizeTypeSuggestTipo = 15;
  final double fontSizeTextToComplete = 15;
  final double fontSizeIconText = 20;
  final double fontSizeButtonText = 20;
  final double paddingMobileHeight = 8;

  //Tablet

  final double paddingTabletHeight = 10;
  final double fontSizeIconTextTablet = 35;
  final double fontSizeTextToCompleteTablet = 20;
  final double fontSizeButtonTextTablet = 25;
  final double fontSizeTypeTablet = 23;
//Desktop
  final double fontSizeButtonTextDestkop = 28;
  final double fontSizeButtonIcon = 29;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    tipo = Provider.of<ActaState>(context).MapOfValue['tipo'];

    return Provider.of<AppState>(context).loading == true
        ? Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text("Loading"),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widget.device.toString() == 'mobile' ? 10 : 20),
            child: Column(
              children: [
                SizedBox(
                  height: widget.device.toString() == 'mobile'
                      ? paddingMobileHeight
                      : paddingTabletHeight,
                ),
                Column(
                  children: [
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          onChanged: Provider.of<ActaState>(context).setId,
                          controller: _typeAheadController,
                          style: TextStyle(
                              color: dark,
                              fontSize: widget.device.toString() == 'mobile'
                                  ? fontSizeTypeAhead
                                  : fontSizeTypeTablet),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.search,
                              color: dark,
                              size: widget.device.toString() == 'mobile'
                                  ? fontSizeTypeAheadIcon
                                  : fontSizeIconTextTablet,
                            ),
                            isDense: true,
                            hintText: 'Codigo interno',
                            border: const OutlineInputBorder(),
                          )),
                      suggestionsCallback: (pattern) async {
                        List<Equipo> equipos = equiposStateProvider.getEquipo();
                        List<String> suggestCodigo = [];
                        for (int i = 0; i < equipos.length; i++) {
                          suggestCodigo.add(equipos[i].id.toString());
                        }
                        return suggestCodigo
                            .where((element) => element
                                .toString()
                                .contains(pattern.toString().toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        List<Equipo> equipos = equiposStateProvider.getEquipo();
                        int index = equipos.lastIndexWhere(
                            (element) => element.id.toString() == suggestion);

                        return ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: TextStyle(fontSize: fontSizeTypeSuggest),
                          ),
                        );
                      },
                      onSuggestionSelected: (String suggestion) {
                        List<Equipo> equipos = equiposStateProvider.getEquipo();
                        _typeAheadController?.text = suggestion;

                        Provider.of<ActaState>(context, listen: false)
                            .setId(suggestion);

                        equipoSelect = equipos.firstWhere((element) =>
                            element.id.toString() == suggestion.toString());
                        Provider.of<ActaState>(context, listen: false)
                            .setEquipo(equipoSelect!);
                        //True -> acta equipo
                        if (equipoSelect!.tipo.contains("Grúa gas") ||
                            equipoSelect!.tipo.contains("Grúa petrolera")) {
                          Provider.of<ActaState>(context, listen: false)
                              .setTipo(true);
                        } else {
                          Provider.of<ActaState>(context, listen: false)
                              .setTipo(false);
                        }
                        //False ->acta electrica
                      },
                    ),
                    SizedBox(
                      height: widget.device.toString() == 'mobile'
                          ? paddingMobileHeight
                          : paddingTabletHeight,
                    ),
                    if (equipoSelect != null)
                      Column(
                        children: [
                          DetalleEquipoWidget(
                            equipoSelect: equipoSelect!,
                          ),
                          SizedBox(
                            height: widget.device.toString() == 'mobile'
                                ? paddingMobileHeight
                                : paddingTabletHeight,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: altureLevanteController,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[0-9]+[,.]{0,1}[0-9]{0,2}$')),
                                    TextInputFormatter.withFunction(
                                      (oldValue, newValue) => newValue.copyWith(
                                        text:
                                            newValue.text.replaceAll(',', '.'),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    Provider.of<ActaState>(context,
                                            listen: false)
                                        .setAlturaLevante(value);
                                  },
                                  style: TextStyle(
                                      color: dark,
                                      fontSize:
                                          widget.device.toString() == 'mobile'
                                              ? fontSizeTextToComplete
                                              : fontSizeTextToCompleteTablet),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                      counterText: '',
                                      suffixText: 'mm',
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueAccent,
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1),
                                      ),
                                      hintText: 'Altura de levante',
                                      prefixIcon: Icon(
                                        Icons.height,
                                        size:
                                            widget.device.toString() == 'mobile'
                                                ? fontSizeIconText
                                                : fontSizeIconTextTablet,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: widget.device.toString() == 'mobile'
                                    ? paddingMobileHeight
                                    : paddingTabletHeight,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: horometroActualController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[0-9]+[,.]{0,1}[0-9]{0,2}$')),
                                    TextInputFormatter.withFunction(
                                      (oldValue, newValue) => newValue.copyWith(
                                        text:
                                            newValue.text.replaceAll(',', '.'),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    Provider.of<ActaState>(context,
                                            listen: false)
                                        .setHorometroActual(value);
                                  },
                                  style: TextStyle(
                                      color: dark,
                                      fontSize:
                                          widget.device.toString() == 'mobile'
                                              ? fontSizeTextToComplete
                                              : fontSizeTextToCompleteTablet),
                                  keyboardType: TextInputType.number,
                                  maxLength: 9,
                                  decoration: InputDecoration(
                                      counterText: '',
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueAccent,
                                            width: 1.0),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1),
                                      ),
                                      hintText: 'Horometro',
                                      prefixIcon: Icon(
                                        Icons.access_alarms_rounded,
                                        size:
                                            widget.device.toString() == 'mobile'
                                                ? fontSizeIconText
                                                : fontSizeIconTextTablet,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: widget.device.toString() == 'mobile'
                                ? paddingMobileHeight
                                : paddingTabletHeight,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 10),
                              child: DropdownButtonFormField<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                                hint: Text(
                                  "Mastil",
                                  style: TextStyle(
                                      fontSize:
                                          widget.device.toString() == 'mobile'
                                              ? fontSizeTextToComplete
                                              : fontSizeTextToCompleteTablet),
                                ),
                                style: TextStyle(color: dark),
                                onChanged: (String? newValue) {
                                  Provider.of<ActaState>(context, listen: false)
                                      .setMastilEquipo(newValue!);
                                },
                                items: <String>[
                                  'Simple',
                                  'Doble',
                                  'Triple'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: widget.device.toString() ==
                                                  'mobile'
                                              ? fontSizeTextToComplete
                                              : fontSizeTextToCompleteTablet),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: widget.device.toString() == 'mobile'
                                ? paddingMobileHeight
                                : paddingTabletHeight,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (widget.device == 'mobile') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MobileRegisterPage(
                                                tipo: tipo,
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage(
                                                tipo: tipo,
                                              )));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.content_paste,
                                    color: Colors.black,
                                    size: widget.device.toString() == 'mobile'
                                        ? 30
                                        : fontSizeButtonIcon,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: widget.device.toString() ==
                                                    'mobile' ||
                                                widget.device.toString() ==
                                                    'tablet'
                                            ? 5
                                            : 10),
                                    child: tipo
                                        ? const Text("Acta de equipo")
                                        : const Text("Acta electrica"),
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                primary: dark,
                                shadowColor: Colors.white,
                                elevation: 5,
                                textStyle: TextStyle(
                                    fontSize: widget.device.toString() ==
                                            'mobile'
                                        ? fontSizeButtonText
                                        : widget.device.toString() == 'tablet'
                                            ? fontSizeButtonTextTablet
                                            : fontSizeButtonTextDestkop,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true; //
}

/*


* */
class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
