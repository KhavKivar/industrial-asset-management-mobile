import 'package:app_licman/ui/tables_pages/movimiento_ui/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../const/Colors.dart';
import '../../../model/inspeccion.dart';
import '../../../model/movimiento.dart';
import '../../../model/state/common_var_state.dart';
import '../../../model/state/app_state.dart';
import '../../../plugins/dart_rut_form.dart';

import '../../view_acta_page/acta_only_view_page.dart';
import '../../view_acta_page/dispatcher_acta_only_view.dart';
import 'card_widget.dart';

class MovTable extends StatefulWidget {
  MovTable(
      {Key? key,
      required this.dataGridController,
      required this.focus,
      required this.device})
      : super(key: key);
  final DataGridController dataGridController;
  final FocusNode focus;
  final String device;

  @override
  _MovTableState createState() => _MovTableState();
}

class _MovTableState extends State<MovTable>
    with AutomaticKeepAliveClientMixin {
  TextEditingController? searchMovController;

  /// Var para controlar el filtro
  bool showFilter = false;
  final fontSizeRowTable = 20.0;

  List<Movimiento> movimientos = [];
  List<Movimiento> movFilterList = [];
  List<Inspeccion> inspecciones = [];
  DateRangePickerController dateController = DateRangePickerController();

  void initVar() {}

  @override
  void initState() {
    /*final now = DateTime.now();
     dateController.selectedDate = DateTime(now.year, now.month);

    searchMovController = TextEditingController(
        text: Provider.of<AppState>(context, listen: false).searchMovText);*/

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      movimientos = Provider.of<AppState>(context, listen: false).movimientos;
      inspecciones =
          Provider.of<AppState>(context, listen: false).inspeccionList;

      Provider.of<AppState>(context, listen: false)
          .setMovimientoList(movimientos);

      //Filtros de tiempo

      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM');
      final String formatted = formatter.format(now);

      List<Movimiento> resultado = movimientos
          .where((element) => element.fechaMov.toString().startsWith(''))
          .toList();

      (resultado.sort(((a, b) => b.fechaMov.compareTo(a.fechaMov))));
      Provider.of<AppState>(context, listen: false).setFilterMovList(resultado);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    //bool checkNull = movFilterList.where((element) => element.equipoId == null).toList().isNotEmpty;
    //if(checkNull){

    //}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: widget.device == 'mobile' ? 10 : 20),
      child: Column(
        children: [
          if (widget.device != 'mobile')
            SizedBox(
              height: 10,
            ),
          Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: dark, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: TextField(
                    controller: searchMovController,
                    focusNode: widget.focus,
                    decoration: InputDecoration(
                      hintText: 'Buscar movimientos..',
                      hintStyle: const TextStyle(fontSize: 20),
                      prefixIcon: const Icon(Icons.search),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      filled: true,
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
                ),
                if (showFilter)
                  Column(
                    children: [
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      FilterPanelMovimientoWidget(
                        DateController: dateController,
                        device: widget.device,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (widget.device == 'desktop')
            SizedBox(
              height: 10,
            ),
          widget.device == 'mobile'
              ? Expanded(
                  child: ListView.builder(
                    itemCount: Provider.of<AppState>(context)
                        .filterMovimientoList
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardMovimientoWidget(
                          movimiento: Provider.of<AppState>(context)
                              .filterMovimientoList[index]);
                    },
                  ),
                )
              : widget.device == 'tablet'
                  ? Expanded(
                      child: Container(
                        color: yellowBackground,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 15,
                              mainAxisExtent: 300,
                            ),
                            shrinkWrap: true,
                            itemCount: Provider.of<AppState>(context)
                                .filterMovimientoList
                                .length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return CardMovimientoWidget(
                                movimiento: Provider.of<AppState>(context)
                                    .filterMovimientoList[index],
                              );
                            },
                          ),
                        ),
                      ),
                    )
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
                              rowHoverColor: Colors.yellow,
                              headerHoverColor: Colors.red,
                              rowHoverTextStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                            child: SfDataGrid(
                              controller: widget.dataGridController,
                              allowSwiping: true,
                              swipeMaxOffset: 130,
                              frozenColumnsCount: 1,
                              onQueryRowHeight: (details) {
                                // Set the row height as 70.0 to the column header row.

                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              startSwipeActionsBuilder: (BuildContext context,
                                  DataGridRow row, int rowIndex) {
                                return GestureDetector(
                                    onTap: () {
                                      final int indexActa =
                                          Provider.of<AppState>(context,
                                                  listen: false)
                                              .inspeccionList
                                              .lastIndexWhere((element) =>
                                                  element.idInspeccion ==
                                                  Provider.of<AppState>(context,
                                                          listen: false)
                                                      .filterMovimientoList[
                                                          rowIndex]
                                                      .idInspeccion);

                                      if (indexActa != -1) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DispatcherActaOnlyView(
                                                        inspeccion: inspecciones[
                                                            indexActa]))).then(
                                            (value) {
                                          if (widget.device == 'mobile' ||
                                              widget.device == 'tablet')
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                        });
                                      }
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
                              source: MovimientoDataSource(
                                  movimientos: Provider.of<AppState>(context)
                                      .filterMovimientoList),
                              columnWidthMode: ColumnWidthMode.fill,
                              columns: columnsMov(true),
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
    Provider.of<AppState>(context, listen: false).setSearchMovText(value);

    List<Movimiento> movimientos =
        Provider.of<AppState>(context, listen: false).movimientos;
    var filtros =
        Provider.of<CommonState>(context, listen: false).listaFiltroMovimientos;
    var fecha = null;

    if (dateController.selectedDate != null) {
      fecha = dateController.selectedDate.toString().split("-")[0] +
          "-" +
          dateController.selectedDate.toString().split("-")[1];
    }
    List<Movimiento> resultado = [];

    switch (filtros) {
      case 0:
        {
          resultado = movimientos
              .where((element) =>
                  element.equipoId.toString().startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.fechaMov.toString().startsWith(fecha)))
              .toList();
        }
        break;
      case 1:
        {
          resultado = movimientos
              .where((element) =>
                  element.nombreCliente
                      .toLowerCase()
                      .startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.fechaMov.toString().startsWith(fecha)))
              .toList();
        }
        break;
      case 2:
        {
          resultado = movimientos
              .where((element) =>
                  (element.rut.startsWith(value.toLowerCase()) ||
                      RUTValidator.deFormat(element.rut)
                          .startsWith(value.toLowerCase())) &&
                  (fecha == null
                      ? true
                      : element.fechaMov.toString().startsWith(fecha)))
              .toList();
        }
        break;

      case 3:
        {
          resultado = movimientos
              .where((element) =>
                  element.idInspeccion
                      .toString()
                      .startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.fechaMov.toString().startsWith(fecha)))
              .toList();
        }
        break;
      case 4:
        {
          resultado = movimientos
              .where((element) =>
                  element.idGuiaDespacho
                      .toString()
                      .startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.fechaMov.toString().startsWith(fecha)))
              .toList();
        }
        break;
    }

    (resultado.sort(((a, b) => b.fechaMov.compareTo(a.fechaMov))));
    Provider.of<AppState>(context, listen: false).setFilterMovList(resultado);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
