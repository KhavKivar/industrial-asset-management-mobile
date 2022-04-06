import 'dart:typed_data';

import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/ui/view_acta_page/font_size.dart';
import 'package:app_licman/ui/view_acta_page/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../intent_file.dart';

class ActaOnlyView extends StatefulWidget {
  const ActaOnlyView({Key? key, required this.inspeccion, this.data, this.tipo})
      : super(key: key);
  final Inspeccion inspeccion;
  final Uint8List? data;
  final String? tipo;
  @override
  _ActaOnlyViewState createState() => _ActaOnlyViewState();
}

class _ActaOnlyViewState extends State<ActaOnlyView> {
  final PageController controller = PageController();
  double page = 0.0;

  void _listenScroll() {
    setState(() {
      page = controller.page!;
    });
  }

  late final controllerMap;
  var itemsFromTitle;
  late final newFieldsMap;
  late final itemSpecial;

  @override
  void initState() {
    super.initState();
    itemSpecial = getTextCamp(widget.inspeccion);
    newFieldsMap = getSelectCamp(widget.inspeccion, widget.inspeccion.tipo);
    itemsFromTitle = getCheckBoxCamp(widget.inspeccion, widget.inspeccion.tipo);
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
    0: "ACCESORIOS",
    1: "SISTEMA HIDRAULICO",
    2: "SISTEMA ELECTRICO",
    3: "CHASIS ESTRUCTURA",
    4: "PRUEBAS DE OPERACION",
    5: "FIRMA Y OBSERVACIONES"
  };

  String selectPage = "ACCESORIOS";

  @override
  Widget build(BuildContext context) {
    dropdownValue = reverseList[page.round()]!;
    selectPage = reverseList[page.round()]!;

    return Scaffold(
        body: Shortcuts(
      manager: LoggingShortcutManager(),
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const ClosePageIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextPageIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const PreviousPageIntent(),
      },
      child: Actions(
        dispatcher: LoggingActionDispatcher(),
        actions: {
          ClosePageIntent: ClosePageAction(context),
          NextPageIntent: NextPageAction(controller),
          PreviousPageIntent: PreviousPageAction(controller),
        },
        child: Focus(
          autofocus: true,
          child: SafeArea(
            child: itemsFromTitle == null
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
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dropdownValue,
                                      icon: const Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                      ),
                                      elevation: 8,
                                      underline: Container(
                                        height: 0,
                                        color: Colors.blueAccent,
                                      ),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSizeTextBarTitle),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                          setState(() {
                                            controller.animateToPage(
                                                itemsPageView[newValue]!,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.easeInOut);
                                            selectPage = newValue;
                                          });
                                        });
                                      },
                                      items: itemsTitle
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: [
                                              Icon(
                                                itemsIcons[value],
                                                color: Colors.white,
                                                size: sizeIconBarTitle,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  value,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          fontSizeTextBarTitle),
                                                ),
                                              ),
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
                                      ? _FirmaAndObservacionesWidget(
                                          data: widget.data,
                                          inspeccion: widget.inspeccion,
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
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  String key =
                                                      itemsFromTitle[selectPage]
                                                          .keys
                                                          .elementAt(index);
                                                  return Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          border: index == 0
                                                              ? Border()
                                                              : Border(
                                                                  top: BorderSide(
                                                                      width:
                                                                          1.5,
                                                                      color:
                                                                          dark),
                                                                )),
                                                      child: _RowContentWidget(
                                                          keyString: key,
                                                          itemSpecial:
                                                              itemSpecial,
                                                          index: index,
                                                          itemsFromTitle:
                                                              itemsFromTitle,
                                                          newFieldsMap:
                                                              newFieldsMap,
                                                          selectPage:
                                                              selectPage,
                                                          tipo: widget.tipo));
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

class _RowContentWidget extends StatelessWidget {
  const _RowContentWidget(
      {Key? key,
      this.tipo,
      required this.keyString,
      required this.newFieldsMap,
      required this.itemSpecial,
      required this.itemsFromTitle,
      required this.selectPage,
      required this.index})
      : super(key: key);
  final tipo;
  final keyString;
  final newFieldsMap;
  final itemSpecial;
  final itemsFromTitle;
  final selectPage;
  final index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      keyString,
                      style: TextStyle(fontSize: fontSizeTextRow),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )),
              Row(
                children: [
                  if (newFieldsMap[keyString] != null)
                    if (tipo == 'desktop')
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(newFieldsMap[keyString][0] +
                            newFieldsMap[keyString][1]),
                      ),
                  if (itemSpecial[keyString] != null)
                    if (tipo == 'desktop')
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text("Cantidad: ${itemSpecial[keyString]}"),
                      ),
                  index == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: tipo.toString() == 'mobile'
                              ? Container()
                              : SizedBox(
                                  width: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Bueno",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Regular",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Malo",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      : tipo.toString() == 'mobile'
                          ? Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Text(
                                itemsFromTitle[selectPage][keyString]![0] ==
                                        true
                                    ? "Bueno"
                                    : itemsFromTitle[selectPage]
                                                [keyString]![1] ==
                                            true
                                        ? "Regular"
                                        : itemsFromTitle[selectPage]
                                                    [keyString]![2] ==
                                                true
                                            ? "Malo"
                                            : "-",
                                style: TextStyle(fontSize: fontSizeTextRow),
                              ),
                            )
                          : SizedBox(
                              width: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: itemsFromTitle[selectPage]
                                        [keyString]![0],
                                    onChanged: (bool? value) {},
                                  ),
                                  Checkbox(
                                    value: itemsFromTitle[selectPage]
                                        [keyString]![1],
                                    onChanged: (bool? value) {},
                                  ),
                                  Checkbox(
                                    value: itemsFromTitle[selectPage]
                                        [keyString]![2],
                                    onChanged: (bool? value) {},
                                  ),
                                ],
                              ),
                            ),
                ],
              )
            ],
          ),
          if (itemSpecial[keyString] != null)
            if (tipo == 'tablet' || tipo == 'mobile')
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Cantidad: ${itemSpecial[keyString]}")),
          if (newFieldsMap[keyString] != null)
            if (tipo == 'tablet' || tipo == 'mobile')
              Column(
                children: [
                  Divider(
                    height: 8,
                    thickness: 0.6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        newFieldsMap[keyString][0] + newFieldsMap[keyString][1],
                        style:
                            TextStyle(fontSize: fontSizeTextRowObservaciones),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

class _RowWidgetObvAndDetails extends StatelessWidget {
  const _RowWidgetObvAndDetails({
    Key? key,
    required this.stringFinal,
    required this.stringInitial,
  }) : super(key: key);
  final String stringInitial;
  final String stringFinal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1.5, color: dark))),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stringInitial,
              style: TextStyle(fontSize: fontSizeTextRow),
            ),
            const SizedBox(
              width: 50,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Text(stringFinal,
                        style: TextStyle(fontSize: fontSizeTextRow))))
          ],
        ),
      ),
    );
  }
}

class _FirmaAndObservacionesWidget extends StatelessWidget {
  const _FirmaAndObservacionesWidget(
      {Key? key, required this.inspeccion, required this.data})
      : super(key: key);
  final Inspeccion inspeccion;
  final data;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                data == null
                    ? SizedBox(
                        height: 200,
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: inspeccion.firmaUrl!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ))
                    : SizedBox(height: 200, child: Image.memory(data!)),
                const SizedBox(
                  height: 20,
                ),
                _RowWidgetObvAndDetails(
                  stringFinal: inspeccion.rut!,
                  stringInitial: 'Rut Cliente',
                ),
                _RowWidgetObvAndDetails(
                  stringFinal: inspeccion.nombre!,
                  stringInitial: 'Nombre Cliente',
                ),
                _RowWidgetObvAndDetails(
                  stringFinal: inspeccion.observacion!,
                  stringInitial: 'Observaciones',
                ),
                _RowWidgetObvAndDetails(
                  stringFinal: inspeccion.alturaLevante!,
                  stringInitial: 'Altura de levante',
                ),
                _RowWidgetObvAndDetails(
                  stringFinal: inspeccion.mastilEquipo!,
                  stringInitial: 'Mastil',
                ),
                _RowWidgetObvAndDetails(
                  stringFinal: inspeccion.horometroActual.toString(),
                  stringInitial: 'Horometro registrado',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
