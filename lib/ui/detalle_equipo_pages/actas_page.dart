import 'package:app_licman/model/inspeccion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../const/Colors.dart';
import '../../model/state/acta_state.dart';
import '../../plugins/dart_rut_form.dart';

import '../create_acta_pages/acta_page_view.dart';
import '../tables_pages/acta_ui/utils.dart';
import '../view_acta_page/acta_only_view_page.dart';
import '../view_acta_page/dispatcher_acta_only_view.dart';
import 'font_size.dart';

class ActaPerEquipoPage extends StatelessWidget {
  ActaPerEquipoPage({Key? key, required this.width, required this.inspecciones})
      : super(key: key);

  final double width;
  final List<Inspeccion> inspecciones;
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            allowSwiping: true,
            swipeMaxOffset: 130,
            source: ActaDataSource(actas: inspecciones),
            columnWidthMode: ColumnWidthMode.fill,
            startSwipeActionsBuilder:
                (BuildContext context, DataGridRow row, int rowIndex) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DispatcherActaOnlyView(
                                inspeccion: inspecciones[rowIndex])));
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
            endSwipeActionsBuilder:
                (BuildContext context, DataGridRow row, int rowIndex) {
              return GestureDetector(
                  onTap: () {
                    Inspeccion acta = inspecciones[rowIndex];
                    Provider.of<ActaState>(context, listen: false)
                        .convertObjectTostate(acta, context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActaPageView(
                                edit: true,
                                id: acta.idInspeccion))).then((value) {});
                  },
                  child: Container(
                      color: Colors.deepPurple,
                      child: const Center(
                        child: Icon(Icons.edit, color: Colors.white, size: 30),
                      )));
            },
            columns: getColumnsActa(false),
          ),
        ),
      ),
    );
  }
}

/*
 *
 * Expanded(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(minWidth: width),
              child: DataTable(
                dataRowHeight: 70,
                showBottomBorder: true,
                sortColumnIndex: 0,
                sortAscending: false,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => dark),
                rows: [
                  for (int i = 0; i < inspecciones.length; i++)
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text(
                          inspecciones[i].idInspeccion.toString(),
                          style: TextStyle(fontSize: fontSizeRowTable),
                        )),
                        DataCell(Text(
                          RUTValidator.formatFromText(inspecciones[i].rut!),
                          style: TextStyle(fontSize: fontSizeRowTable),
                        )),
                        DataCell(Text(
                          inspecciones[i].alturaLevante.toString(),
                          style: TextStyle(fontSize: fontSizeRowTable),
                        )),
                        DataCell(Text(
                          formatter.format(inspecciones[i].ts!),
                          style: TextStyle(fontSize: fontSizeRowTable),
                        )),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DispatcherActaOnlyView(
                                                  inspeccion:
                                                      inspecciones[i])));
                                },
                              ),
                              IconButton(
                                  onPressed: () {
                                    Inspeccion acta = inspecciones[i];
                                    Provider.of<ActaState>(context,
                                            listen: false)
                                        .convertObjectTostate(acta, context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ActaPageView(
                                                edit: true,
                                                id: acta.idInspeccion)));
                                  },
                                  icon: const Icon(Icons.edit_sharp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
                columns: [
                  DataColumn(
                    label: Text(
                      'Acta ID',
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSizeRowHead),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Rut cliente',
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSizeRowHead),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Altura [mm]',
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSizeRowHead),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Fecha',
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSizeRowHead),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Acciones',
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSizeRowHead),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
 */