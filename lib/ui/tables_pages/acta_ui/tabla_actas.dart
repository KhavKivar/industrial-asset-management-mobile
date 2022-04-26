import 'package:app_licman/ui/tables_pages/acta_ui/card_acta_widget.dart';
import 'package:app_licman/ui/tables_pages/acta_ui/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../const/Colors.dart';
import '../../../model/inspeccion.dart';
import '../../../model/state/acta_state.dart';
import '../../../model/state/common_var_state.dart';
import '../../../model/state/app_state.dart';
import '../../../plugins/dart_rut_form.dart';

import '../../create_acta_pages/acta_page_view.dart';

import '../../create_acta_pages/dispatcher_acta_pages.dart';
import '../../view_acta_page/acta_only_view_page.dart';
import '../../view_acta_page/dispatcher_acta_only_view.dart';

class ActaTable extends StatefulWidget {
  const ActaTable(
      {Key? key,
      required this.provSelectState,
      required this.width,
      required this.dataGridController,
      required this.actaFocusController,
      this.device})
      : super(key: key);
  final dynamic provSelectState;
  final double width;
  final DataGridController dataGridController;
  final FocusNode actaFocusController;
  final String? device;

  @override
  _ActaTableState createState() => _ActaTableState();
}

class _ActaTableState extends State<ActaTable>
    with AutomaticKeepAliveClientMixin {
  bool showFilter = false;
  DateRangePickerController dateController = DateRangePickerController();
  TextEditingController? searchController;
  final fontSizeRowTable = 20.0;
  final fontSizeRowHead = 25.0;

  List<Inspeccion> filterList = [];
  List<Inspeccion> inspecciones = [];

  @override
  void initState() {
    final now = DateTime.now();
    dateController.selectedDate = DateTime(now.year, now.month);

    searchController = TextEditingController(
        text: Provider.of<AppState>(context, listen: false).searchActasText);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      inspecciones =
          Provider.of<AppState>(context, listen: false).inspeccionList;
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM');
      final String formatted = formatter.format(now);

      List<Inspeccion> resultado = inspecciones
          .where((element) => element.ts.toString().startsWith(formatted))
          .toList();
      Provider.of<AppState>(context, listen: false).setFilterList(resultado);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    filterList = Provider.of<AppState>(context).filterInspeccionList;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: widget.device == 'mobile' ? 10 : 20),
      child: Column(
        children: [
          if (widget.device.toString() != 'mobile')
            SizedBox(
              height: 10,
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: dark, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    focusNode: widget.actaFocusController,
                    style: TextStyle(color: dark, fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Buscar actas..',
                      hintStyle: const TextStyle(fontSize: 20),
                      prefixIcon: const Icon(Icons.search),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          focusNode: FocusNode(skipTraversal: true),
                          onPressed: () {
                            setState(() {
                              showFilter = !showFilter;
                            });
                          },
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            color: dark,
                            size: 25,
                          )),
                    ),
                    onChanged: (value) {
                      logicaFiltros(value);
                    },
                  ),
                  if (showFilter)
                    Column(
                      children: [
                        Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                        FilterPanelWidget(
                          dateController: dateController,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          widget.device == 'mobile'
              ? Expanded(
                  child: ListView.builder(
                  itemCount: Provider.of<AppState>(context)
                      .filterInspeccionList
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardActaWidget(
                        inspeccion: Provider.of<AppState>(context)
                            .filterInspeccionList[index]);
                  },
                ))
              : Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Focus(
                      descendantsAreFocusable: false,
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                          headerColor: dark,
                          headerHoverColor: Colors.red,
                          rowHoverColor: Colors.yellow,
                          rowHoverTextStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        child: SfDataGrid(
                          controller: widget.dataGridController,
                          allowSwiping: true,
                          frozenColumnsCount: 1,
                          swipeMaxOffset: 130,
                          source: ActaDataSource(
                              actas: Provider.of<AppState>(context)
                                  .filterInspeccionList),
                          columnWidthMode: ColumnWidthMode.fill,
                          startSwipeActionsBuilder: (BuildContext context,
                              DataGridRow row, int rowIndex) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DispatcherActaOnlyView(
                                                      inspeccion: filterList[
                                                          rowIndex])))
                                      .then((value) {
                                    if (widget.device == 'mobile' ||
                                        widget.device == 'tablet')
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                  });
                                },
                                child: Container(
                                    color: Colors.deepPurple,
                                    child: const Center(
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    )));
                          },
                          endSwipeActionsBuilder: (BuildContext context,
                              DataGridRow row, int rowIndex) {
                            return GestureDetector(
                                onTap: () {
                                  Inspeccion acta = filterList[rowIndex];
                                  Provider.of<ActaState>(context, listen: false)
                                      .convertObjectTostate(acta, context);
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DispatcherActaCreatePages(
                                                      edit: true,
                                                      id: acta.idInspeccion)))
                                      .then((value) {
                                    Provider.of<CommonState>(context,
                                            listen: false)
                                        .changeActaIndex(0);
                                    if (widget.device == 'mobile' ||
                                        widget.device == 'tablet')
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                  });
                                },
                                child: Container(
                                    color: Colors.deepPurple,
                                    child: const Center(
                                      child: Icon(Icons.edit,
                                          color: Colors.white, size: 30),
                                    )));
                          },
                          columns: getColumnsActa(true),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void logicaFiltros(value) {
    Provider.of<AppState>(context, listen: false).setSearchActa(value);

    var actas = Provider.of<AppState>(context, listen: false).inspeccionList;
    var filtros = Provider.of<CommonState>(context, listen: false).listaFiltro;
    var fecha = null;
    if (dateController.selectedDate != null) {
      fecha = dateController.selectedDate.toString().split("-")[0] +
          "-" +
          dateController.selectedDate.toString().split("-")[1];
    }

    switch (filtros) {
      case 0:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  element.idInspeccion
                      .toString()
                      .startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();

          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;
      case 1:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  element.idEquipo.toString().startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();
          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;
      case 2:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  (element.rut!.startsWith(value.toLowerCase()) ||
                      RUTValidator.deFormat(element.rut!)
                          .startsWith(value.toLowerCase())) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();
          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;

      case 3:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  element.ts.toString().startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();
          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
