import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/state/common_var_state.dart';
import 'package:app_licman/plugins/dart_rut_form.dart';
import 'package:app_licman/ui/tables_pages/acta_ui/tabla_actas.dart';
import 'package:app_licman/ui/tables_pages/movimiento_ui/tabla_movimientos.dart';

import 'package:app_licman/widget/bottomNavigator.dart';
import 'package:app_licman/widget/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../intent_file.dart';
import '../../widget/row_navigator_widget.dart';
import '../create_acta_pages/acta_page_view.dart';
import '../create_acta_pages/dispatcher_acta_pages.dart';

class TableOfActas extends StatefulWidget {
  const TableOfActas({Key? key, this.device}) : super(key: key);
  final String? device;
  @override
  _TableOfActasState createState() => _TableOfActasState();
}

class _TableOfActasState extends State<TableOfActas> {
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
      int selectON = Provider.of<CommonState>(context, listen: false).tabSelect;
      if (selectON == 1) {
        if (controller.hasClients) {
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
    Provider.of<CommonState>(context, listen: false).setTabSelect(nt);
    if (widget.device == 'mobile' || widget.device == 'tablet') {
      return;
    }

    if (nt == 0) {
      actaFocus.requestFocus();
    } else {
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
        title: const Text("Actas y movimientos"),
        backgroundColor: dark,
      ),
      drawer: MyDrawer(
        device: widget.device,
      ),
      bottomNavigationBar: const BottomNavigator(),
      floatingActionButton: widget.device == 'mobile'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 1000),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      child: child,
                      opacity:
                          animation.drive(CurveTween(curve: Curves.elasticOut)),
                    );
                  },
                  child: Provider.of<CommonState>(context).tabSelect == 0
                      ? FloatingActionButton(
                          backgroundColor: dark,
                          heroTag: "mov",
                          onPressed: () {
                            Provider.of<CommonState>(context, listen: false)
                                .setTabSelect(1);
                            controller.animateToPage(1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          },
                          child: Icon(
                            Icons.swap_vert,
                            color: yellowBackground,
                          ),
                        )
                      : FloatingActionButton(
                          backgroundColor: dark,
                          heroTag: "actas",
                          onPressed: () {
                            Provider.of<CommonState>(context, listen: false)
                                .setTabSelect(0);
                            controller.animateToPage(0,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          },
                          child: Icon(
                            Icons.content_paste,
                            color: yellowBackground,
                          ),
                        ),
                ),
              ],
            )
          : FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              heroTag: "add",
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DispatcherActaCreatePages()),
                ).then((value) {
                  Provider.of<CommonState>(context, listen: false)
                      .changeActaIndex(0);
                });
              }),
      floatingActionButtonLocation: widget.device == 'mobile'
          ? FloatingActionButtonLocation.startFloat
          : widget.device == 'tablet'
              ? FloatingActionButtonLocation.endDocked
              : FloatingActionButtonLocation.endFloat,
      body: Shortcuts(
        manager: LoggingShortcutManager(),
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextPageIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft):
              const PreviousPageIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): const ClosePageIntent()
        },
        child: Actions(
          dispatcher: LoggingActionDispatcher(),
          actions: {
            NextPageIntent: NextPageAction(controller, changeSelectItem),
            PreviousPageIntent:
                PreviousPageAction(controller, changeSelectItem),
            ClosePageIntent: ClosePageAction(context, changeItemSelectOnBar)
          },
          child: SafeArea(
            child: Builder(builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.device.toString() != 'mobile')
                    _NavigatorTwoItem(
                      controller: controller,
                      select: select,
                    ),
                  Expanded(
                    child: PageView(
                      controller: controller,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Shortcuts(
                          manager: LoggingShortcutManager(),
                          shortcuts: <LogicalKeySet, Intent>{
                            LogicalKeySet(LogicalKeyboardKey.arrowUp):
                                const UpIntent(),
                            LogicalKeySet(LogicalKeyboardKey.arrowDown):
                                const DownIntent(),
                          },
                          child: Actions(
                            dispatcher: LoggingActionDispatcher(),
                            actions: {
                              DownIntent: DownAction(dataGridControllerActa),
                              UpIntent: UpAction(dataGridControllerActa),
                            },
                            child: ActaTable(
                                provSelectState: provSelectState,
                                width: width,
                                dataGridController: dataGridControllerActa,
                                actaFocusController: actaFocus,
                                device: widget.device),
                          ),
                        ),
                        Shortcuts(
                            manager: LoggingShortcutManager(),
                            shortcuts: <LogicalKeySet, Intent>{
                              LogicalKeySet(LogicalKeyboardKey.arrowUp):
                                  const UpIntent(),
                              LogicalKeySet(LogicalKeyboardKey.arrowDown):
                                  const DownIntent(),
                            },
                            child: Actions(
                                dispatcher: LoggingActionDispatcher(),
                                actions: {
                                  DownIntent:
                                      DownAction(dataGridControllerMovimiento),
                                  UpIntent:
                                      UpAction(dataGridControllerMovimiento),
                                },
                                child: MovTable(
                                    focus: movFocus,
                                    dataGridController:
                                        dataGridControllerMovimiento,
                                    device: widget.device.toString())))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: widget.device == 'mobile' ? 10 : 20,
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavigatorTwoItem extends StatefulWidget {
  const _NavigatorTwoItem(
      {Key? key, required this.controller, required this.select})
      : super(key: key);
  final controller;
  final int select;
  @override
  _NavigatorTwoItemState createState() => _NavigatorTwoItemState();
}

class _NavigatorTwoItemState extends State<_NavigatorTwoItem> {
  final double fontSizeNav = 25.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 53,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                Provider.of<CommonState>(context, listen: false)
                    .setTabSelect(0);
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
                Provider.of<CommonState>(context, listen: false)
                    .setTabSelect(1);
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
