import 'package:app_licman/const/Strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../const/Colors.dart';
import '../../../model/movimiento.dart';
import '../../../model/state/common_var_state.dart';
import '../../../model/state/app_state.dart';
import '../../responsive_layout.dart';

class MovimientoDataSource extends DataGridSource {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  MovimientoDataSource({required List<Movimiento> movimientos}) {
    _movData = movimientos
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'fecha_mov', value: formatter.format(e.fechaMov)),
              DataGridCell<String>(columnName: 'equipo_id', value: e.equipoId),
              DataGridCell<String>(
                  columnName: 'transporte', value: e.transporte.toString()),
              DataGridCell<String>(
                  columnName: 'Empresa', value: e.nombreCliente),
              DataGridCell<String>(
                  columnName: 'tipo', value: e.tipo.capitalize()),
              DataGridCell<int>(columnName: 'Acta ID', value: e.idInspeccion),
              DataGridCell<int>(
                  columnName: 'N° Guia despacho', value: e.idGuiaDespacho),
              DataGridCell<String>(
                  columnName: 'Cambio',
                  value: e.cambio == null ? "" : e.cambio.toString()),
              DataGridCell<String>(
                  columnName: 'Observaciones',
                  value: e.observaciones == null
                      ? ""
                      : e.observaciones.toString()),
              DataGridCell<String>(
                  columnName: 'fecha_retiro',
                  value: e.fechaRetiro == null
                      ? ""
                      : formatter.format(e.fechaRetiro!))
            ]))
        .toList();
  }

  List<DataGridRow> _movData = [];

  @override
  List<DataGridRow> get rows => _movData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          padding: e.columnName == 'Empresa'
              ? EdgeInsets.all(3.0)
              : EdgeInsets.all(8.0),
          child: Align(
            alignment: e.columnName == 'Observaciones'
                ? Alignment.topLeft
                : Alignment.center,
            child: Text(
              e.value.toString(),
              softWrap: true,
              style:
                  e.columnName == 'Observaciones' || e.columnName == 'Empresa'
                      ? TextStyle(
                          fontSize: 18,
                        )
                      : TextStyle(fontSize: 20),
            ),
          ),
        );
      });
    }).toList());
  }

  void print_contrains(BoxConstraints constraints) {
    print("Min Width : ${constraints.minWidth}");
    print("Max Width : ${constraints.maxWidth}");
    print("Min Height : ${constraints.minHeight}");
    print("Max Height : ${constraints.maxHeight}");
  }
}

class FilterPanelMovimientoWidget extends StatefulWidget {
  FilterPanelMovimientoWidget(
      {Key? key, required this.DateController, required this.device})
      : super(key: key);
  final DateController;
  final String device;

  @override
  _FilterPanelWidgetState createState() => _FilterPanelWidgetState();
}

class _FilterPanelWidgetState extends State<FilterPanelMovimientoWidget> {
  final List<String> _filterOptions = [
    'Codigo interno',
    'Nombre empresa',
    'Rut empresa',
    'Acta Id',
    'Guia de despacho',
  ];
  int _filtroBusqueda = 0;

  @override
  void initState() {
    _filtroBusqueda =
        Provider.of<CommonState>(context, listen: false).listaFiltroMovimientos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
        ),
        child: Row(children: [
          Expanded(
              child: Container(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calendario',
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        isMobileOrTablet(getDevice(context))
                            ? IconButton(
                                onPressed: () {
                                  widget.DateController.selectedDate = null;
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.date_range_sharp,
                                  color: Colors.blueAccent,
                                ),
                              )
                            : Flexible(
                                child: Container(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: ElevatedButton(
                                    onPressed: () {
                                      widget.DateController.selectedDate = null;
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Seleccionar todo",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                      ),
                                    )),
                              ))
                      ],
                    ),
                    content: Container(
                      width: 500.w,
                      height: 400.h,
                      constraints:
                          BoxConstraints(maxWidth: 500, maxHeight: 600),
                      child: SfDateRangePickerTheme(
                        data: SfDateRangePickerThemeData(
                            todayCellTextStyle: TextStyle(
                              fontSize: 35.sp,
                              color: Colors.black,
                            ),
                            headerTextStyle:
                                TextStyle(fontSize: 35.sp, color: Colors.black),
                            selectionTextStyle: TextStyle(fontSize: 35.sp),
                            cellTextStyle: TextStyle(
                                fontSize: 35.sp, color: Colors.black)),
                        child: SfDateRangePicker(
                          initialSelectedDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          controller: widget.DateController,
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            if (args.value != null) {
                              var fecha = args.value.toString().split("-")[0] +
                                  "-" +
                                  args.value.toString().split("-")[1];
                              List<Movimiento> resultado =
                                  Provider.of<AppState>(context, listen: false)
                                      .movimientos
                                      .where((element) => element.fechaMov
                                          .toString()
                                          .startsWith(fecha))
                                      .toList();
                              (resultado.sort(((a, b) =>
                                  b.fechaMov.compareTo(a.fechaMov))));
                              Provider.of<AppState>(context, listen: false)
                                  .setFilterMovList(resultado);

                              setState(() {
                                widget.DateController.selectedDate = args.value;
                              });
                            } else {
                              List<Movimiento> resultado =
                                  Provider.of<AppState>(context, listen: false)
                                      .movimientos;
                              (resultado.sort(((a, b) =>
                                  b.fechaMov.compareTo(a.fechaMov))));
                              Provider.of<AppState>(context, listen: false)
                                  .setFilterMovList(resultado);
                            }
                          },
                          allowViewNavigation: false,
                          view: DateRangePickerView.year,
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (widget.DateController.selectedDate != null) {
                            var fecha = widget.DateController.selectedDate
                                    .toString()
                                    .split("-")[0] +
                                "-" +
                                widget.DateController.selectedDate
                                    .toString()
                                    .split("-")[1];
                            List<Movimiento> resultado =
                                Provider.of<AppState>(context, listen: false)
                                    .movimientos
                                    .where((element) => element.fechaMov
                                        .toString()
                                        .startsWith(fecha))
                                    .toList();
                            (resultado.sort(
                                ((a, b) => b.fechaMov.compareTo(a.fechaMov))));
                            Provider.of<AppState>(context, listen: false)
                                .setFilterMovList(resultado);
                          }

                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filtros de fecha",
                      style: TextStyle(fontSize: 16, color: dark),
                    ),
                    Text(
                      widget.DateController.selectedDate == null
                          ? ""
                          : widget.DateController.selectedDate
                                  .toString()
                                  .split("-")[0] +
                              "-" +
                              widget.DateController.selectedDate
                                  .toString()
                                  .split("-")[1],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          )),
          const SizedBox(
            height: 40,
            child: VerticalDivider(
              width: 9,
              thickness: 1,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: SmartSelect<int>.single(
                title: 'Filtros de busqueda',
                modalTitle: 'Filtros de busqueda',
                modalType: S2ModalType.popupDialog,
                choiceType: S2ChoiceType.chips,
                choiceItems: S2Choice.listFrom<int, String>(
                  source: _filterOptions,
                  value: (index, item) => index,
                  title: (index, item) => item,
                ),
                modalHeaderStyle: S2ModalHeaderStyle(
                    iconTheme: IconThemeData(
                      color: Colors.white, //change your color here
                    ),
                    backgroundColor: dark,
                    textStyle: TextStyle(color: Colors.white)),
                modalStyle: const S2ModalStyle(backgroundColor: Colors.white),
                choiceStyle: const S2ChoiceStyle(
                  color: Colors.black,
                ),
                value: _filtroBusqueda,
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    trailing: const Icon(Icons.arrow_drop_down),
                    isTwoLine: true,
                  );
                },
                onChange: (state) {
                  Provider.of<CommonState>(context, listen: false)
                      .setFiltroMov(state.value);
                }),
          ),
        ]));
  }
}

List<GridColumn> columnsMov(bool borderTop) {
  final fontSizeRowHead = 25.0;
  return <GridColumn>[
    GridColumn(
        columnName: 'fecha_mov',
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        minimumWidth: 150,
        label: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: borderTop
                  ? BorderRadius.only(topLeft: Radius.circular(5))
                  : BorderRadius.zero,
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: borderTop
                ? Text(
                    'Fecha',
                    style: TextStyle(
                        color: Colors.white, fontSize: fontSizeRowHead),
                  )
                : Text(
                    'Fecha',
                    style: TextStyle(
                        color: Colors.white, fontSize: fontSizeRowHead),
                  ))),
    if (borderTop)
      GridColumn(
          columnName: 'equipo_id',
          minimumWidth: 130,
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: AutoSizeText('Codigo interno',
                  style: TextStyle(
                      color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'transporte',
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Transporte',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'Empresa',
        minimumWidth: 200,
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Empresa',
                softWrap: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeRowHead,
                )))),
    GridColumn(
        columnName: 'tipo',
        minimumWidth: 150,
        columnWidthMode: ColumnWidthMode.fitByCellValue,
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Tipo',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSizeRowHead,
                    overflow: TextOverflow.ellipsis)))),
    GridColumn(
        columnName: 'Acta ID',
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Acta ID',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'N° Guia despacho',
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: AutoSizeText('N° Guia despacho',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'Cambio',
        minimumWidth: 150,
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Cambio',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'Observaciones',
        minimumWidth: 200,
        label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Observaciones',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'fecha_retiro',
        minimumWidth: 150,
        label: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Fecha retiro',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
  ];
}
