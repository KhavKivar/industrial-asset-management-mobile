import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/state/actaState.dart';
import 'package:app_licman/model/state/equipoState.dart';
import 'package:app_licman/plugins/dart_rut_form.dart';
import 'package:app_licman/ui/tabla_actas/all_actas_page.dart';
import 'package:app_licman/ui/ui_acta/acta_inspeccion_page.dart';
import 'package:app_licman/ui/ui_creacion_acta/acta_general_page.dart';
import 'package:app_licman/ui/ui_creacion_acta/acta_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../model/movimiento.dart';
import 'ui_acta/acta_only_view_page.dart';

class cardEquipoDetalle extends StatefulWidget {
  const cardEquipoDetalle({Key? key, required this.equipo}) : super(key: key);
  final Equipo equipo;

  @override
  _cardEquipoDetalleState createState() => _cardEquipoDetalleState();
}

class _cardEquipoDetalleState extends State<cardEquipoDetalle> {
  var choose = 0;
  final fontSizeHead = 20.0;
  final fontSizeContent = 20.0;
  final fontSizeRowTable = 20.0;
  final fontSizeRowHead = 25.0;


  List<Inspeccion> inspecciones = [];
  List<Movimiento> movimientos = [];
  DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  var numberFormatter =  NumberFormat.decimalPattern('de-DE');
  @override
  void didChangeDependencies() {
    inspecciones = Provider.of<EquipoState>(context)
        .inspeccionList
        .where((element) => element.idEquipo == widget.equipo.id)
        .toList();
    final clientes = Provider.of<EquipoState>(context,listen: false).clientes;
    movimientos = Provider.of<EquipoState>(context)
        .movimientos.where((element) =>  inspecciones.where((x) => x.idInspeccion == element.idInspeccion).toList().length > 0 ).toList();
    for(int i=0;i<movimientos.length;i++){
      int indexCliente = clientes.indexWhere((element) => element.rut.toString() == movimientos[i].rut.toString());
      if(indexCliente != -1){
        movimientos[i].nombreCliente = clientes[indexCliente].nombre;
      }else{
        movimientos[i].nombreCliente = "";
      }

    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(backgroundColor: dark,title: Text("Equipo"),),
      body: Shortcuts(
        manager: LoggingShortcutManager(),
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.escape): const  closePageIntent(),


        },

        child: Actions(
          dispatcher: LoggingActionDispatcher(),
          actions: {
            closePageIntent: closePageAction(context),


          },
          child: Focus(
autofocus: true,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Hero(
                  tag: widget.equipo.id,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            choose = 0;
                                          });
                                        },
                                        child: Container(
                                            margin:EdgeInsetsDirectional.zero,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.article,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "Detalle",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: fontSizeHead),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: choose == 0
                                                    ? Colors.blueAccent
                                                    : dark,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12)))),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            choose = 1;
                                          });
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(top: 0),
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.content_paste,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "Actas",
                                                        overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: fontSizeHead),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: choose == 1
                                                  ? Colors.blueAccent
                                                  : dark,
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            choose = 2;
                                          });
                                        },
                                        child: Container(
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.swap_vert,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text("Movimientos",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: fontSizeHead)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: choose == 2
                                                    ? Colors.blueAccent
                                                    : dark,

                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12)


                                                ))),
                                      ),
                                    ),
                                  ],
                                ),
                                if (choose == 0)
                                  Expanded(
                                    child: Column(
                                      children: [
                                        RowWidget(
                                          value: widget.equipo.id.toString(),
                                          title: 'Codigo interno',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.estado,
                                          title: 'Estado',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.ubicacion,
                                          title: 'Ubicacion',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.tipo,
                                          title: 'Tipo',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.modelo,
                                          title: 'Modelo',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.marca,
                                          title: 'Marca',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.serie,
                                          title: 'Serie',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.altura.toString().replaceAll(".", ",")+" mm",
                                          title: 'Altura',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),

                                        RowWidget(
                                          value: numberFormatter.format(widget.equipo.capacidad).toString()+" Kg",
                                          title: 'Capacidad',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.mastil,
                                          title: 'Mastil',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: numberFormatter.format(widget.equipo.horometro).toString(),
                                          title: 'Horometro',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: false,
                                        ),
                                        RowWidget(
                                          value: widget.equipo.ano.toString(),
                                          title: 'Año',
                                          fontSizeContent: fontSizeContent,
                                          borderBool: true,
                                        ),
                                      ],
                                    ),
                                  )
                                else if (choose == 1)
                                  if (inspecciones.isNotEmpty)
                                    Expanded(
                                      child: Container(
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
                                                  for (int i = 0;
                                                      i < inspecciones.length;
                                                      i++)
                                                    DataRow(

                                                      cells: <DataCell>[
                                                        DataCell(Text(inspecciones[i]
                                                            .idInspeccion
                                                            .toString(),style: TextStyle(fontSize: fontSizeRowTable),
                                                        )
                                                        ),
                                                        DataCell(

                                                            Text(RUTValidator.formatFromText(inspecciones[i].rut!),style: TextStyle(fontSize: fontSizeRowTable),)),

                                                        DataCell(
                                                            Text(inspecciones[i].alturaLevante.toString(),style: TextStyle(fontSize: fontSizeRowTable),)),
                                                        DataCell(Text(formatter
                                                            .format(inspecciones[i].ts!),style: TextStyle(fontSize: fontSizeRowTable),)),

                                                        DataCell(
                                                            Row(

                                                              children: [

                                                                IconButton(icon: Icon(Icons.visibility), onPressed: () {
                                                          Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                  builder: (context) =>
                                                                  ActaOnlyView(inspeccion: inspecciones[i])));
                                                        },),
                                                                IconButton(onPressed: (){
                                                                  Inspeccion acta = inspecciones[i];
                                                                  Provider.of<ActaState>(context,listen: false).convertObjectTostate(acta, context);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ActaPageView(edit: true,id:acta.idInspeccion) ));

                                                                }, icon: Icon(Icons.edit_sharp)),
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
                                                      style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Rut cliente',
                                                      style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                    ),
                                                  ),



                                                  DataColumn(
                                                    label: Text(
                                                      'Altura [mm]',
                                                      style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                    ),
                                                  ),

                                                  DataColumn(
                                                    label: Text(
                                                      'Fecha',
                                                      style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Acciones',
                                                      style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      child: Center(
                                          child: Text(
                                        "No hay actas todavia",
                                        style: TextStyle(fontSize: 25),
                                      )),
                                    )
                                else
                                  movimientos.length == 0 ?  Container(
                                    child: Center(
                                        child: Text(
                                          "No hay movimientos todavia",
                                          style: TextStyle(fontSize: 25),
                                        )),
                                  ): Expanded(
                                    child: Container(
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
                                                for (int i = 0;
                                                i < movimientos.length;
                                                i++)
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Text(formatter
                                                          .format(movimientos[i].fechaMov),style: TextStyle(fontSize: fontSizeRowTable),
                                                      )),

                                                      DataCell(
                                                          Text(movimientos[i].transporte,style: TextStyle(fontSize: fontSizeRowTable),)),
                                                      DataCell(
                                                          Text(movimientos[i].nombreCliente,style: TextStyle(fontSize: fontSizeRowTable),)),
                                                      DataCell(
                                                          Text(movimientos[i].tipo,style: TextStyle(fontSize: fontSizeRowTable),)),

                                                      DataCell(Text(movimientos[i].idInspeccion.toString(),style: TextStyle(fontSize: fontSizeRowTable),)),
                                                      DataCell(Text(movimientos[i].idGuiaDespacho.toString(),style: TextStyle(fontSize: fontSizeRowTable),)),
                                                      DataCell(Text(
                                                        movimientos[i].fechaRetiro ==null ? "":
                                                        formatter
                                                          .format(movimientos[i].fechaRetiro!),style: TextStyle(fontSize: fontSizeRowTable),)),
                                                      DataCell(
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: IconButton(icon: Icon(Icons.visibility), onPressed: () {
                                                             int  indexActa =inspecciones.indexWhere((element) => element.idInspeccion == movimientos[i].idInspeccion);
                                                            if(indexActa != -1){
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ActaOnlyView(inspeccion: inspecciones[indexActa])));
                                                            }

                                                          },),
                                                        ),

                                                      ),

                                                    ],
                                                  ),
                                              ],
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'Fecha',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),


                                                DataColumn(
                                                  label: Text(
                                                    'Transporte',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Empresa',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Tipo',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),



                                                DataColumn(
                                                  label: Text(
                                                    'Acta ID',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'N° Guia despacho',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Fecha de retiro',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Acciones',
                                                    style: TextStyle(color: Colors.white,fontSize: fontSizeRowHead),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  const RowWidget(
      {Key? key,
      required this.title,
      required this.value,
      required this.fontSizeContent,
      required this.borderBool})
      : super(key: key);
  final String title;
  final String value;
  final double fontSizeContent;
  final bool borderBool;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border:Border(top: BorderSide(width: 1.5,color: dark)),

          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: fontSizeContent),
                ),
                Text(
                  value,
                  style:
                      TextStyle(fontSize: fontSizeContent, color: Colors.grey),
                ),
              ],
            ),
          )),
    );
  }
}
