import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/state/app_state.dart';
import 'package:app_licman/ui/tables_pages/acta_ui/card_acta_widget.dart';
import 'package:app_licman/ui/tables_pages/movimiento_ui/card_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../intent_file.dart';
import '../../model/movimiento.dart';
import 'actas_page.dart';
import 'detalle_page.dart';
import 'font_size.dart';
import 'mov_page.dart';

class CardEquipoDetalle extends StatefulWidget {
  const CardEquipoDetalle({
    Key? key,
    required this.equipo,
    required this.tipo,
  }) : super(key: key);
  final Equipo equipo;
  final String tipo;

  @override
  _CardEquipoDetalleState createState() => _CardEquipoDetalleState();
}

class _CardEquipoDetalleState extends State<CardEquipoDetalle> {
  int choose = 0;

  List<Inspeccion> inspecciones = [];
  List<Movimiento> movimientos = [];
  DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  var numberFormatter = NumberFormat.decimalPattern('de-DE');
  @override
  void didChangeDependencies() {
    inspecciones = Provider.of<AppState>(context)
        .inspeccionList
        .where((element) => element.idEquipo == widget.equipo.id)
        .toList();
    final clientes = Provider.of<AppState>(context, listen: false).clientes;
    movimientos = Provider.of<AppState>(context)
        .movimientos
        .where((element) => inspecciones
            .where((x) => x.idInspeccion == element.idInspeccion)
            .toList()
            .isNotEmpty)
        .toList();
    for (int i = 0; i < movimientos.length; i++) {
      int indexCliente = clientes.indexWhere(
          (element) => element.rut.toString() == movimientos[i].rut.toString());
      if (indexCliente != -1) {
        movimientos[i].nombreCliente = clientes[indexCliente].nombre;
      } else {
        movimientos[i].nombreCliente = "";
      }
    }

    super.didChangeDependencies();
  }

  changeNavBarItemChoosen(int itemToChange) {
    setState(() {
      choose = itemToChange;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark,
        title: const Text("Equipo"),
        elevation: 0,
      ),
      body: Shortcuts(
        manager: LoggingShortcutManager(),
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.escape): const ClosePageIntent(),
        },
        child: Actions(
          dispatcher: LoggingActionDispatcher(),
          actions: {
            ClosePageIntent: ClosePageAction(context),
          },
          child: Focus(
            autofocus: true,
            child: Hero(
                tag: widget.equipo.id,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                _TopNavigatorItem(
                                  callBack: changeNavBarItemChoosen,
                                  choose: choose,
                                  title: 'Detalle',
                                  itemNumber: 0,
                                  tipo: widget.tipo,
                                ),
                                _TopNavigatorItem(
                                    callBack: changeNavBarItemChoosen,
                                    choose: choose,
                                    title: 'Actas',
                                    itemNumber: 1,
                                    tipo: widget.tipo),
                                _TopNavigatorItem(
                                    callBack: changeNavBarItemChoosen,
                                    choose: choose,
                                    title: 'Movimientos',
                                    itemNumber: 2,
                                    tipo: widget.tipo),
                              ],
                            ),
                            if (choose == 0)
                              DetailPage(
                                equipo: widget.equipo,
                              )
                            else if (choose == 1)
                              if (inspecciones.isNotEmpty)
                                Expanded(
                                  child: Container(
                                    color: yellowBackground,
                                    child: ListView.builder(
                                      itemCount: inspecciones.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: CardActaWidget(
                                              inspeccion: inspecciones[index]),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else
                                const Center(
                                    child: Text(
                                  "No hay actas todavia",
                                  style: TextStyle(fontSize: 25),
                                ))
                            else
                              movimientos.isEmpty
                                  ? const Center(
                                      child: Text(
                                      "No hay movimientos todavia",
                                      style: TextStyle(fontSize: 25),
                                    ))
                                  : Expanded(
                                      child: Container(
                                        color: yellowBackground,
                                        child: ListView.builder(
                                          itemCount: movimientos.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: CardMovimientoWidget(
                                                  movimiento:
                                                      movimientos[index]),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class _TopNavigatorItem extends StatelessWidget {
  _TopNavigatorItem(
      {Key? key,
      required this.callBack,
      required this.choose,
      required this.title,
      required this.itemNumber,
      required this.tipo})
      : super(key: key);

  final dynamic callBack;
  final int choose;
  final String title;
  final int itemNumber;
  final String tipo;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          callBack(itemNumber);
        },
        child: Container(
            margin: EdgeInsetsDirectional.zero,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  if (tipo != 'mobile')
                    Icon(
                      itemNumber == 0
                          ? Icons.article
                          : itemNumber == 1
                              ? Icons.content_paste
                              : Icons.swap_vert,
                      color: Colors.white,
                      size: 30,
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSizeHead),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: choose == itemNumber ? Colors.blueAccent : dark,
            )),
      ),
    );
  }
}
