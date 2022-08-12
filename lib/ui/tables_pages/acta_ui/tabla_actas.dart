import 'package:app_licman/ui/tables_pages/acta_ui/card_acta_widget.dart';
import 'package:app_licman/ui/tables_pages/acta_ui/utils.dart';
import 'package:app_licman/ui/tables_pages/acta_ui/widget.dart';
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

  final fontSizeRowTable = 20.0;
  final fontSizeRowHead = 25.0;

  List<Inspeccion> filterList = [];
  List<Inspeccion> inspecciones = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      inspecciones =
          Provider.of<AppState>(context, listen: false).inspeccionList;
      /*final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM');
      final String formatted = formatter.format(now);

      List<Inspeccion> resultado = inspecciones
          .where((element) => element.ts.toString().startsWith(formatted))
          .toList();
      Provider.of<AppState>(context, listen: false).setFilterList(resultado);*/
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
              height: 5,
            ),
          SearchWidgetActa(),
          if (widget.device == 'desktop')
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
                            .filterInspeccionList[index],
                        device: widget.device.toString(),
                      );
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
                              crossAxisSpacing: 15,
                              mainAxisExtent: 230,
                            ),
                            shrinkWrap: true,
                            itemCount: Provider.of<AppState>(context)
                                .filterInspeccionList
                                .length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return CardActaWidget(
                                inspeccion: Provider.of<AppState>(context)
                                    .filterInspeccionList[index],
                                device: widget.device.toString(),
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
                              onQueryRowHeight: (details) {
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
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
                                                          rowIndex]))).then(
                                          (value) {
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
                                      Provider.of<ActaState>(context,
                                              listen: false)
                                          .convertObjectTostate(acta, context);
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DispatcherActaCreatePages(
                                                          edit: true,
                                                          id: acta
                                                              .idInspeccion)))
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
