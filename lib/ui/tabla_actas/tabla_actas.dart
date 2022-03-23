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
import '../../model/state/actaState.dart';
import '../../model/state/commonVarState.dart';
import '../../model/state/equipoState.dart';
import '../../plugins/dart_rut_form.dart';
import '../ui_acta/acta_only_view_page.dart';
import '../ui_creacion_acta/acta_page_view.dart';

class ActaTable extends StatefulWidget {
  const ActaTable({Key? key, required this.provSelectState,required this.width,required this.dataGridController, required this.actaFocusController}) : super(key: key);
  final provSelectState, width;
  final DataGridController dataGridController;
  final FocusNode actaFocusController;

  @override
  _ActaTableState createState() => _ActaTableState();
}

class _ActaTableState extends State<ActaTable> {
  bool showFilter = false;
  DateRangePickerController DateController = DateRangePickerController() ;
  TextEditingController? searchController;
  final fontSizeRowTable = 20.0;
  final fontSizeRowHead = 25.0;


  List<Inspeccion> filterList = [];
  List<Inspeccion> inspecciones = [];



  @override
  void initState() {
    final now = DateTime.now();
    DateController.selectedDate = DateTime(now.year,now.month);

    searchController =  TextEditingController(  text:Provider.of<EquipoState>(context,listen: false).searchActasText);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      inspecciones =
          Provider
              .of<EquipoState>(context, listen: false)
              .inspeccionList;
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM');
      final String formatted = formatter.format(now);

      List<Inspeccion> resultado  = inspecciones
          .where((element) =>
          element.ts.toString().startsWith(formatted)
      ).toList();
      Provider
          .of<EquipoState>(context, listen: false)
          .setFilterList(resultado);

      filterList =  Provider
          .of<EquipoState>(context, listen: false)
          .filterInspeccionList;


    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  Padding(
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
              controller: searchController,
              focusNode: widget.actaFocusController,
              decoration: InputDecoration(
                hintText: 'Buscar actas..',
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

                Provider.of<EquipoState>(context,listen: false).setSearchActa(value);

                var actas = Provider.of<EquipoState>(context,listen: false).inspeccionList;
                var filtros = Provider.of<CommonState>(context, listen: false)
                    .listaFiltro;
                var fecha = null;
                if(DateController.selectedDate != null){
                  fecha  = DateController.selectedDate.toString().split("-")[0]+"-"+DateController.selectedDate.toString().split("-")[1];
                  print("fecha ${fecha}");
                }

                switch (filtros) {
                  case 0:
                    {

                      List<Inspeccion> resultado = actas
                          .where((element) => element.idInspeccion
                          .toString()
                          .startsWith(value.toLowerCase()) && (fecha == null ? true :
                      element.ts.toString().startsWith(fecha))  )
                          .toList();

                      Provider.of<EquipoState>(context,listen: false).setFilterList(resultado);
                    }
                    break;
                  case 1:
                    {
                      List<Inspeccion> resultado  = actas
                          .where((element) => element.idEquipo
                          .toString()
                          .startsWith(value.toLowerCase()) && (fecha == null ? true :
                      element.ts.toString().startsWith(fecha)) )
                          .toList();
                      Provider.of<EquipoState>(context,listen: false).setFilterList(resultado);
                    }
                    break;
                  case 2:
                    {
                      List<Inspeccion> resultado  = actas
                          .where((element) =>(
                      element.rut!.startsWith(value.toLowerCase()) ||
                          RUTValidator.deFormat(element.rut!)
                              .startsWith(value.toLowerCase()) ) && (fecha == null ? true :
                          element.ts.toString().startsWith(fecha) ))
                          .toList();
                      Provider.of<EquipoState>(context,listen: false).setFilterList(resultado);
                    }
                    break;

                  case 3:
                    {
                      List<Inspeccion> resultado  = actas
                          .where((element) => element.ts
                          .toString()
                          .startsWith(value.toLowerCase())&& (fecha == null ? true :
                      element.ts.toString().startsWith(fecha)))
                          .toList();
                      Provider.of<EquipoState>(context,listen: false).setFilterList(resultado);
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
                FilterPanelWidget(DateController: DateController,),
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
                  headerHoverColor: Colors.red,
                  rowHoverColor: Colors.yellow,
                  rowHoverTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                child: SfDataGrid(


                  controller: widget.dataGridController,
                  allowSwiping: true,
                  source: ActaDataSource(actas: Provider
                      .of<EquipoState>(context)
                      .filterInspeccionList),
                  columnWidthMode: ColumnWidthMode.fill,
                  startSwipeActionsBuilder:
                      (BuildContext context, DataGridRow row,
                      int rowIndex) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActaOnlyView(
                                          inspeccion:
                                          filterList[
                                          rowIndex])));
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
                  endSwipeActionsBuilder: (BuildContext context,
                      DataGridRow row, int rowIndex) {
                    return GestureDetector(
                        onTap: () {
                          print(rowIndex);
                          Inspeccion acta =
                          filterList[rowIndex];
                          Provider.of<ActaState>(context,
                              listen: false)
                              .convertObjectTostate(
                              acta, context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActaPageView(
                                          edit: true,
                                          id: acta
                                              .idInspeccion)))
                              .then((value) {
                            Provider.of<CommonState>(context,
                                listen: false)
                                .changeActaIndex(0);
                          });
                        },
                        child: Container(
                            color: Colors.deepPurple,
                            child: Center(
                              child: Icon(Icons.edit,
                                  color: Colors.white,
                                  size: 30),
                            )));
                  },
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'acta_id',
                        minimumWidth: 150,
                        label: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                              const BorderRadius.only(
                                topLeft: Radius.circular(5),
                              ),
                            ),
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'ID',
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
                                    fontSize:
                                    fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'rut',
                        minimumWidth: 150,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Rut',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                    fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'altura',
                        minimumWidth: 150,
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Altura [mm]',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                    fontSizeRowHead)))),
                    GridColumn(
                        columnName: 'fecha',
                        minimumWidth: 150,
                        label: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.only(
                                topRight: Radius.circular(5),
                              ),
                            ),
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Fecha',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                    fontSizeRowHead)))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class FilterPanelWidget extends StatefulWidget {
  const FilterPanelWidget({Key? key,required this.DateController}) : super(key: key);
  final DateController;

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
                                List<Inspeccion> resultado  = Provider.of<EquipoState>(context,listen: false).inspeccionList
                                    .where((element) =>
                                    element.ts.toString().startsWith(fecha)
                                )
                                    .toList();
                                Provider.of<EquipoState>(context,listen: false).setFilterList(resultado);


                                setState(() {
                                  widget.DateController.selectedDate = args.value;
                                });
                              }else{
                                Provider.of<EquipoState>(context,listen: false).setFilterList(Provider.of<EquipoState>(context,listen: false).inspeccionList);
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