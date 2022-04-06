import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../const/Colors.dart';
import '../../../model/inspeccion.dart';
import '../../../model/state/common_var_state.dart';
import '../../../model/state/app_state.dart';
import '../../../plugins/dart_rut_form.dart';

class FilterPanelWidget extends StatefulWidget {
  const FilterPanelWidget({Key? key, required this.dateController})
      : super(key: key);
  final DateRangePickerController dateController;

  @override
  _FilterPanelWidgetState createState() => _FilterPanelWidgetState();
}

class _FilterPanelWidgetState extends State<FilterPanelWidget> {
  final List<String> _categoriesOption = [
    'Acta ID',
    'ID Equipo',
    'Rut cliente',
    'Altura de levante',
    'Fecha',
  ];

  final List<String> _filterOptions = [
    'Acta ID',
    'ID Equipo',
    'Rut cliente',
    'Fecha',
  ];
  List<int> _categories = [0];
  int _filtroBusqueda = 1;

  @override
  void initState() {
    _categories = Provider.of<CommonState>(context, listen: false).categories;
    _filtroBusqueda =
        Provider.of<CommonState>(context, listen: false).listaFiltro;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
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
                        const Text('Calendario'),
                        SizedBox(
                          width: 5.w,
                        ),
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: ElevatedButton(
                                onPressed: () {
                                  widget.dateController.selectedDate = null;
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Seleccionar todo",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                  ),
                                )),
                          ),
                        )
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
                          controller: widget.dateController,
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            if (args.value != null) {
                              var fecha = args.value.toString().split("-")[0] +
                                  "-" +
                                  args.value.toString().split("-")[1];
                              List<Inspeccion> resultado =
                                  Provider.of<AppState>(context, listen: false)
                                      .inspeccionList
                                      .where((element) => element.ts
                                          .toString()
                                          .startsWith(fecha))
                                      .toList();
                              Provider.of<AppState>(context, listen: false)
                                  .setFilterList(resultado);

                              setState(() {
                                widget.dateController.selectedDate = args.value;
                              });
                            } else {
                              Provider.of<AppState>(context, listen: false)
                                  .setFilterList(Provider.of<AppState>(context,
                                          listen: false)
                                      .inspeccionList);
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
                          if (widget.dateController.selectedDate != null) {
                            var fecha = widget.dateController.selectedDate
                                    .toString()
                                    .split("-")[0] +
                                "-" +
                                widget.dateController.selectedDate
                                    .toString()
                                    .split("-")[1];
                            List<Inspeccion> resultado =
                                Provider.of<AppState>(context, listen: false)
                                    .inspeccionList
                                    .where((element) =>
                                        element.ts.toString().startsWith(fecha))
                                    .toList();
                            Provider.of<AppState>(context, listen: false)
                                .setFilterList(resultado);
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
                      widget.dateController.selectedDate == null
                          ? ""
                          : widget.dateController.selectedDate
                                  .toString()
                                  .split("-")[0] +
                              "-" +
                              widget.dateController.selectedDate
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
                      .changeSelectFiltro(state.value);
                }),
          ),
        ]));
  }
}

class ActaDataSource extends DataGridSource {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  /// Creates the employee data source class with required details.
  ActaDataSource({required List<Inspeccion> actas}) {
    _actaData = actas
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'acta_id', value: e.idInspeccion),
              DataGridCell<int>(columnName: 'equipo_id', value: e.idEquipo),
              DataGridCell<String>(
                  columnName: 'rut',
                  value: RUTValidator.formatFromText(e.rut.toString())),
              DataGridCell<String>(
                  columnName: 'altura',
                  value: e.alturaLevante.toString().replaceAll(".", ",")),
              DataGridCell<String>(
                  columnName: 'fecha', value: formatter.format(e.ts!)),
            ]))
        .toList();
  }

  List<DataGridRow> _actaData = [];

  @override
  List<DataGridRow> get rows => _actaData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int index = effectiveRows.indexOf(row);
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
          style: TextStyle(fontSize: 20),
        ),
      );
    }).toList());
  }
}

List<GridColumn> getColumnsActa(bool borderTop) {
  final fontSizeRowHead = 25.0;

  return <GridColumn>[
    GridColumn(
        columnName: 'acta_id',
        minimumWidth: 150,
        label: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: borderTop
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(5),
                    )
                  : BorderRadius.zero,
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              'ID',
              style: TextStyle(color: Colors.white, fontSize: fontSizeRowHead),
            ))),
    GridColumn(
        columnName: 'equipo_id',
        minimumWidth: 190,
        label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Codigo interno',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'rut',
        minimumWidth: 150,
        label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Rut',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'altura',
        minimumWidth: 150,
        label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Altura [mm]',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
    GridColumn(
        columnName: 'fecha',
        minimumWidth: 150,
        label: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
              ),
            ),
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Fecha',
                style: TextStyle(
                    color: Colors.white, fontSize: fontSizeRowHead)))),
  ];
}
