import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/state/commonVarState.dart';
import 'package:app_licman/model/state/equipoState.dart';
import 'package:app_licman/plugins/dart_rut_form.dart';
import 'package:app_licman/ui/tabla_actas/tabla_actas.dart';
import 'package:app_licman/ui/tabla_actas/tabla_movimientos.dart';
import 'package:app_licman/widget/bottomNavigator.dart';
import 'package:app_licman/widget/drawer.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../main.dart';
import '../../model/movimiento.dart';
import '../../model/state/actaState.dart';
import '../ui_acta/acta_only_view_page.dart';
import '../ui_creacion_acta/acta_page_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
                  columnName: 'rut',
                  value: RUTValidator.formatFromText(e.rut.toString())),
              DataGridCell<String>(columnName: 'tipo', value: e.tipo),
              DataGridCell<int>(columnName: 'Acta ID', value: e.idInspeccion),
              DataGridCell<int>(
                  columnName: 'N° Guia despacho', value: e.idGuiaDespacho),
              DataGridCell<String>(
                  columnName: 'Cambio',
                  value: e.cambio == null ? "" : e.cambio.toString()),
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

class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    super.invokeAction(action, intent, context);

    return null;
  }
}

class TableOfActas extends StatefulWidget {
  const TableOfActas({Key? key}) : super(key: key);

  @override
  _TableOfActasState createState() => _TableOfActasState();
}

class _TableOfActasState extends State<TableOfActas>
     {
  final fontSizeRowTable = 20.0;
  final fontSizeRowHead = 25.0;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  final PageController controller = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    select = Provider.of<CommonState>(context).tabSelect;
  }

  int select = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      int selectON = Provider.of<CommonState>(context,listen: false).tabSelect;
      if(selectON == 1){
        if(controller.hasClients){
          print("enter");
          controller.jumpToPage(1);
        }

      }

    });

  }


  String dropdownValue = 'Actas';
  List<String> itemsTitle = [
    "Actas",
    "Movimientos",
  ];
  Map<String, IconData> itemsIcons = {
    "Actas": Icons.content_paste,
    "Movimientos": Icons.swap_vert,
  };




  changeSelectItem(int nt) {
    Provider.of<CommonState>(context,listen: false).setTabSelect(nt);

      if(nt == 0){
        actaFocus.requestFocus();
      }else{
        movFocus.requestFocus();
      }

  }

  changeItemSelectOnBar() {
    Provider.of<CommonState>(context, listen: false).changeIndex(0);
  }

  DataGridController dataGridControllerActa = DataGridController();
  DataGridController dataGridControllerMovimiento = DataGridController();
  final FocusNode actaFocus = FocusNode();
  final FocusNode movFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var provSelectState = Provider.of<CommonState>(context).categories;
    return Scaffold(
      appBar: AppBar(
        title: Text("Actas y movimientos"),
        backgroundColor: dark,
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: const BottomNavigator(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActaPageView()),
            ).then((value) {
              Provider.of<CommonState>(context, listen: false)
                  .changeActaIndex(0);
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Shortcuts(
        manager: LoggingShortcutManager(),
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowRight): const nextPageIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft):
              const previousPageIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): const closePageIntent()
        },
        child: Actions(
          dispatcher: LoggingActionDispatcher(),
          actions: {
            nextPageIntent: nextPageAction(controller, changeSelectItem),
            previousPageIntent:
                previousPageAction(controller, changeSelectItem),
            closePageIntent: closePageAction(context, changeItemSelectOnBar)
          },
          child: SafeArea(
            child: FocusScope(
              autofocus: true,
                onFocusChange: (hasFocus) {

                  if(hasFocus) {
                    // do stuff
                  }
                },
              child: Builder(
                builder: (BuildContext context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      NavigatorTwoItem(
                        controller: controller,
                        select: select,
                      ),
                      Expanded(
                        child: PageView(
                          controller: controller,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Shortcuts(
                              manager: LoggingShortcutManager(),
                              shortcuts: <LogicalKeySet, Intent>{
                                LogicalKeySet(LogicalKeyboardKey.arrowUp):
                                    const upIntent(),
                                LogicalKeySet(LogicalKeyboardKey.arrowDown):
                                    const downIntent(),
                              },
                              child: Actions(
                                dispatcher: LoggingActionDispatcher(),
                                actions: {
                                  downIntent: downAction(dataGridControllerActa),
                                  upIntent: upAction(dataGridControllerActa),
                                },
                                child: ActaTable(

                                  provSelectState: provSelectState,
                                  width: width,
                                  dataGridController: dataGridControllerActa,
                                  actaFocusController: actaFocus,
                                ),
                              ),
                            ),
                            Shortcuts(
                                manager: LoggingShortcutManager(),
                                shortcuts: <LogicalKeySet, Intent>{
                                  LogicalKeySet(LogicalKeyboardKey.arrowUp):
                                      const upIntent(),
                                  LogicalKeySet(LogicalKeyboardKey.arrowDown):
                                      const downIntent(),
                                },
                                child: Actions(
                                    dispatcher: LoggingActionDispatcher(),
                                    actions: {
                                      downIntent:
                                          downAction(dataGridControllerMovimiento),
                                      upIntent:
                                          upAction(dataGridControllerMovimiento),
                                    },
                                    child: MovTable(
                                      focus:movFocus,
                                        dataGridController:
                                            dataGridControllerMovimiento)))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigatorTwoItem extends StatefulWidget {
  NavigatorTwoItem({Key? key, required this.controller, required this.select})
      : super(key: key);
  final controller;
  int select;
  @override
  _NavigatorTwoItemState createState() => _NavigatorTwoItemState();
}

class _NavigatorTwoItemState extends State<NavigatorTwoItem> {
  final double fontSizeNav = 25.0;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {

                  Provider.of<CommonState>(context,listen: false).setTabSelect(0);
                  widget.controller.animateToPage(0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut);

              },
              child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: widget.select == 0 ? Colors.blueAccent : dark,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      )),
                  child: RowNavigator(
                    iconData: Icons.content_paste,
                    title: "Actas",
                    fontSizeText: fontSizeNav,
                  )),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Provider.of<CommonState>(context,listen: false).setTabSelect(1);
                widget.controller.animateToPage(1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              },
              child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.select == 1 ? Colors.blueAccent : dark,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: RowNavigator(
                    iconData: Icons.swap_vert,
                    title: "Movimientos",
                    fontSizeText: fontSizeNav,
                  )),
            )),
          ],
        ),
      ),
    );
  }
}
