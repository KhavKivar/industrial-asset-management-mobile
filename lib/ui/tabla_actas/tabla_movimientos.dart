

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../const/Colors.dart';
import '../../model/inspeccion.dart';
import '../../model/movimiento.dart';
import '../../model/state/commonVarState.dart';
import '../../model/state/equipoState.dart';
import '../../plugins/dart_rut_form.dart';
import '../ui_acta/acta_only_view_page.dart';




class MovTable extends StatefulWidget {
  const MovTable({Key? key, required this.dataGridController, required this.focus}) : super(key: key);
  final DataGridController dataGridController;
  final FocusNode focus;

  @override
  _MovTableState createState() => _MovTableState();
}


class _MovTableState extends State<MovTable> {


  TextEditingController?  searchMovController;
  /// Var para controlar el filtro
  bool showFilter = false;
  final fontSizeRowTable = 20.0;
  final fontSizeRowHead = 25.0;

  List<Movimiento> movimientos = [];
  List<Movimiento> movFilterList = [];
  List<Inspeccion> inspecciones = [];
  DateRangePickerController DateController = DateRangePickerController() ;

  void initVar(){

  }

  @override
  void initState() {
    final now = DateTime.now();
    DateController.selectedDate = DateTime(now.year,now.month);

    searchMovController =  TextEditingController(  text:Provider.of<EquipoState>(context,listen: false).searchMovText);


    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {





      movimientos =
          Provider
              .of<EquipoState>(context, listen: false)
              .movimientos;
      final clientes = Provider.of<EquipoState>(context,listen: false).clientes;
      inspecciones =
          Provider
              .of<EquipoState>(context, listen: false)
              .inspeccionList;
      for (int i = 0; i < movimientos.length; i++) {
        movimientos[i].equipoId = inspecciones
            .firstWhere((element) =>
        element.idInspeccion == movimientos[i].idInspeccion)
            .idEquipo
            .toString();
        movimientos[i].nombreCliente = clientes.firstWhere((element) => element.rut.toString() == movimientos[i].rut.toString()).nombre.toString();
      }

      Provider
          .of<EquipoState>(context, listen: false)
          .setMovimientoList(movimientos);


      //Filtros de tiempo
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM');
      final String formatted = formatter.format(now);



      List<Movimiento> resultado  = movimientos
          .where((element) =>
          element.fechaMov.toString().startsWith(formatted)
      ).toList();


    Provider.of<EquipoState>(context,listen: false).setFilterMovList(resultado);




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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [

          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: (!showFilter)
                    ? BorderRadius.all(Radius.circular(25))
                    : BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5)),
                color: Colors.white),
            child: TextField(
              controller: searchMovController,
              focusNode: widget.focus,
              decoration: InputDecoration(
                hintText: 'Buscar movimientos..',
                hintStyle: TextStyle(fontSize: 21),
                prefixIcon: Icon(Icons.search),
                fillColor: Colors.white,
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
                Provider.of<EquipoState>(context,listen: false).setSearchMovText(value);

                List<Movimiento> movimientos = Provider.of<EquipoState>(context,listen: false).movimientos;
                var filtros = Provider.of<CommonState>(context, listen: false)
                    .listaFiltroMovimientos;
                var fecha = null;

                if(DateController.selectedDate != null){
                  fecha  = DateController.selectedDate.toString().split("-")[0]+"-"+DateController.selectedDate.toString().split("-")[1];
                  print("fecha ${fecha}");
                }

                switch (filtros) {
                  case 0:
                    {
                      List<Movimiento> resultado = movimientos
                          .where((element) =>
                      element.equipoId
                          .toString()
                          .startsWith(value.toLowerCase()) &&
                          (fecha == null ? true :
                          element.fechaMov.toString().startsWith(fecha)))
                          .toList();

                      Provider.of<EquipoState>(context, listen: false)
                          .setFilterMovList(resultado);
                    }
                    break;
                  case 1:
                    {
                      List<Movimiento> resultado = movimientos
                          .where((element) =>
                      element.nombreCliente.toLowerCase()
                          .startsWith(value.toLowerCase()) &&
                          (fecha == null ? true :
                          element.fechaMov.toString().startsWith(fecha)))
                          .toList();
                      Provider.of<EquipoState>(context, listen: false)
                          .setFilterMovList(resultado);
                    }
                    break;
                  case 2:
                    {
                      List<Movimiento> resultado = movimientos
                          .where((element) =>(
                      element.rut.startsWith(value.toLowerCase()) ||
                          RUTValidator.deFormat(element.rut)
                              .startsWith(value.toLowerCase()) ) &&
                              (fecha == null ? true :
                              element.fechaMov.toString().startsWith(fecha)))
                          .toList();
                      Provider.of<EquipoState>(context, listen: false)
                          .setFilterMovList(resultado);
                    }
                    break;

                  case 3:
                    {
                      List<Movimiento> resultado = movimientos
                          .where((element) =>
                      element.idInspeccion
                          .toString()
                          .startsWith(value.toLowerCase()) &&
                          (fecha == null ? true :
                          element.fechaMov.toString().startsWith(fecha)))
                          .toList();
                      Provider.of<EquipoState>(context, listen: false)
                          .setFilterMovList(resultado);
                    }
                    break;
                  case 4:
                    {
                      List<Movimiento> resultado = movimientos
                          .where((element) =>
                      element.idGuiaDespacho
                          .toString()
                          .startsWith(value.toLowerCase()) &&
                          (fecha == null ? true :
                          element.fechaMov.toString().startsWith(fecha)))
                          .toList();
                      Provider.of<EquipoState>(context, listen: false)
                          .setFilterMovList(resultado);
                    }
                    break;
                }


              },
            ),
          ),
          if (showFilter)
            Column(
              children: [
                const Divider(
                  height: 0.3,
                  thickness: 0.6,
                  color: Colors.black87,
                ),
                FilterPanelMovimientoWidget(DateController: DateController,),
              ],
            ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: dark,
                  rowHoverColor: Colors.yellow,
                  headerHoverColor: Colors.red,
                  rowHoverTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                child: SfDataGrid(
                  controller: widget.dataGridController,
                  allowSwiping: true,

                  startSwipeActionsBuilder:
                      (BuildContext context, DataGridRow row,
                      int rowIndex) {
                    return GestureDetector(
                        onTap: () {
                          final int indexActa = inspecciones.lastIndexWhere((element) => element.idInspeccion ==
                              Provider.of<EquipoState>(context,listen: false).filterMovimientoList[rowIndex].idInspeccion );
                          if(indexActa != -1)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActaOnlyView(
                                          inspeccion:

                                          inspecciones[indexActa])));
                        },
                        child: Container(
                            color: Colors.deepPurple,
                            child: Center(
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                                size: 30,
                              ),
                            )));
                  },
                  source: MovimientoDataSource(movimientos: Provider.of<EquipoState>(context).filterMovimientoList),
                  columnWidthMode: ColumnWidthMode.fill,

                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'fecha_mov',
                        minimumWidth: 230,
                        label: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                              ),
                            ),
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Fecha Movimiento',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSizeRowHead),
                            ))),
                    GridColumn(
                        columnName: 'equipo_id',
                        minimumWidth: 190,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Codigo interno',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'transporte',
                        minimumWidth: 150,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Transporte',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'Empresa',
                        minimumWidth: 200,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Empresa',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead,overflow: TextOverflow.ellipsis)))),
                    GridColumn(
                        columnName: 'tipo',
                        minimumWidth: 150,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Tipo',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'Acta ID',
                        minimumWidth: 150,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Acta ID',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'N° Guia despacho',
                        minimumWidth: 250,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('N° Guia despacho',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'Cambio',
                        minimumWidth: 150,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Cambio',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'Observaciones',
                        minimumWidth: 200,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Observaciones',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'fecha_retiro',
                        minimumWidth: 150,
                        label: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                              ),
                            ),
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Fecha retiro',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeRowHead)))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );;
  }
}


























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
          columnName: 'Empresa',
          value:e.nombreCliente),
      DataGridCell<String>(columnName: 'tipo', value: e.tipo),
      DataGridCell<int>(columnName: 'Acta ID', value: e.idInspeccion),
      DataGridCell<int>(
          columnName: 'N° Guia despacho', value: e.idGuiaDespacho),
      DataGridCell<String>(
          columnName: 'Cambio',
          value: e.cambio == null ? "" : e.cambio.toString()),
      DataGridCell<String>(
          columnName: 'Observaciones',
          value: e.observaciones == null ? "" : e.observaciones.toString()),
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
          return
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){

              return Container(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment:  e.columnName == 'Observaciones'  ? Alignment.topLeft :Alignment.center,
                  child: Text(
                    e.value.toString(),
                    style:  e.columnName == 'Observaciones'||  e.columnName == 'Empresa' ?TextStyle(fontSize: 18): TextStyle(fontSize: 20),
                  ),
                ),
              );
            }
          );

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
  const FilterPanelMovimientoWidget({Key? key,required this.DateController}) : super(key: key);
  final DateController;

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
              child: Container(width: double.infinity,
                child: InkWell(
                  onTap: (){
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Calendario'),
                            ElevatedButton(onPressed: (){
                              widget.DateController.selectedDate=null;
                              Navigator.pop(context);

                            }, child: Text("Seleccionar todo"))
                          ],
                        ),
                        content:  Container(
                          width: 400,
                          height: 300,
                          child: SfDateRangePicker(
                            initialSelectedDate: DateTime( DateTime.now().year,  DateTime.now().month,  DateTime.now()  .day),
                            controller:widget.DateController,
                            onSelectionChanged:(DateRangePickerSelectionChangedArgs args){
                              if(args.value != null){


                                var fecha = args.value.toString().split("-")[0]+"-"+args.value.toString().split("-")[1];
                                List<Movimiento> resultado  = Provider.of<EquipoState>(context,listen: false).movimientos
                                    .where((element) =>
                                    element.fechaMov.toString().startsWith(fecha)
                                )
                                    .toList();
                                Provider.of<EquipoState>(context,listen: false).setFilterMovList(resultado);


                                setState(() {
                                  widget.DateController.selectedDate = args.value;
                                });
                              }else{
                                Provider.of<EquipoState>(context,listen: false).setFilterMovList(Provider.of<EquipoState>(context,listen: false).movimientos);
                              }

                            },
                            allowViewNavigation:false,
                            view: DateRangePickerView.year,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Filtros de fecha",style: TextStyle(fontSize: 16,color: dark),),
                        Text(
                          widget.DateController.selectedDate == null  ?

                          ""

                              :
                          widget.DateController.selectedDate.toString().split("-")[0]+
                              "-"  +
                              widget.DateController.selectedDate.toString().split("-")[1]


                          ,style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ),)
          ),
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
