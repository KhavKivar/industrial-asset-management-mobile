import 'package:app_licman/model/movimiento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../const/Colors.dart';
import '../../model/inspeccion.dart';

import '../../model/state/app_state.dart';
import '../tables_pages/movimiento_ui/utils.dart';
import '../view_acta_page/acta_only_view_page.dart';
import '../view_acta_page/dispatcher_acta_only_view.dart';
import 'font_size.dart';

class MovEquipoPage extends StatelessWidget {
  MovEquipoPage(
      {Key? key,
      required this.width,
      required this.movimientos,
      required this.inspecciones,
      this.tipo})
      : super(key: key);
  final double width;
  final List<Movimiento> movimientos;
  final List<Inspeccion> inspecciones;
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  final tipo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            allowSwiping: true,
            swipeMaxOffset: 130,
            startSwipeActionsBuilder:
                (BuildContext context, DataGridRow row, int rowIndex) {
              return GestureDetector(
                  onTap: () {
                    int indexActa = inspecciones.indexWhere((element) =>
                        element.idInspeccion ==
                        movimientos[rowIndex].idInspeccion);

                    if (indexActa != -1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DispatcherActaOnlyView(
                                  inspeccion: inspecciones[indexActa])));
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
            source: MovimientoDataSourceDetalle(movimientos: movimientos),
            columnWidthMode: ColumnWidthMode.fill,
            columns: columnsMov(false),
          ),
        ),
      ),
    );
  }
}

class MovimientoDataSourceDetalle extends DataGridSource {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  MovimientoDataSourceDetalle({required List<Movimiento> movimientos}) {
    _movData = movimientos
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'fecha_mov', value: formatter.format(e.fechaMov)),
              DataGridCell<String>(
                  columnName: 'transporte', value: e.transporte.toString()),
              DataGridCell<String>(
                  columnName: 'Empresa', value: e.nombreCliente),
              DataGridCell<String>(columnName: 'tipo', value: e.tipo),
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
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: e.columnName == 'Observaciones'
                ? Alignment.topLeft
                : Alignment.center,
            child: Text(
              e.value.toString(),
              style:
                  e.columnName == 'Observaciones' || e.columnName == 'Empresa'
                      ? TextStyle(fontSize: 18)
                      : TextStyle(fontSize: 20),
            ),
          ),
        );
      });
    }).toList());
  }
}
