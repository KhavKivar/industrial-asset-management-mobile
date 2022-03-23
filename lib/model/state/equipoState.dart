import 'package:app_licman/Repository/EquipoRepository.dart';
import 'package:app_licman/Repository/clienteRepositor.dart';
import 'package:app_licman/Repository/movimientoRepository.dart';
import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/services/inventario/equiposServices.dart';
import 'package:flutter/material.dart';

import '../../Repository/ImgRepository.dart';
import '../../Repository/InspeccionRepository.dart';
import '../../Repository/colaRepository.dart';
import '../../Repository/updateResourcesRepository.dart';
import '../cliente.dart';
import '../cola.dart';
import '../equipo.dart';
import '../inspeccion.dart';
import '../modeloimagen.dart';

class EquipoState extends ChangeNotifier {
  List<Equipo> equipos = [];
  List<Equipo> filterListEquipo = [];
  List<Inspeccion> inspeccionList = [];
  List<Inspeccion> filterInspeccionList = [];

  List<ModeloImg> imgList = [];
  List<Cola> listCola = [];
  List<Movimiento> movimientos = [];
  List<Movimiento> filterMovimientoList = [];
  List<Cliente> clientes = [];

  String searchActasText = "";
  String searchMovText = "";

  dynamic contextMain;


  int indexCola = -1;

  setClientes(List<Cliente> n_clientes){
    clientes = n_clientes;
    notifyListeners();
  }

  setSearchMovText(String text){
    searchMovText = text;
    notifyListeners();
  }
  setIndexCola(int index){
    indexCola = index;
  }

  setSearchActa(String text){
    searchActasText = text;
    notifyListeners();

  }

  bool loading = false;
  addActa(Inspeccion acta){
    inspeccionList.insert(0,acta);
    filterInspeccionList.insert(0, acta);
    notifyListeners();
  }
  setActa(Inspeccion acta){
    int index = inspeccionList.indexWhere((element) => element.idInspeccion == acta.idInspeccion);
    print(" index ${index}");
    if(index != -1){
      print(" Modificar");
      inspeccionList[index] = acta;
      final indexFiltro = filterInspeccionList.indexWhere((element) => element.idInspeccion == acta.idInspeccion);
      if(indexFiltro!=-1) {
        filterInspeccionList[indexFiltro] = acta;
      }
    }
    notifyListeners();
  }

  removeCola(Cola cola){
    int indexCola = listCola.indexWhere((element) => element.data == cola.data);
    if(indexCola != -1){
      print(indexCola);
      listCola.removeAt(indexCola);
    }
    notifyListeners();
  }

  addCola(Cola cola){
    listCola.add(cola);
    notifyListeners();
  }
  getEquipo(){
    return equipos;
  }
  setHorometro(int idEquipo,double hor){
    int  indexEquipo = equipos.lastIndexWhere((element) => element.id==idEquipo);
    if(equipos[indexEquipo].horometro < hor){

      equipos[indexEquipo].horometro = hor;
    }
    filterListEquipo = [...equipos];
    notifyListeners();

  }
  setEquipo(List<Equipo> newListOfEquipos){
    equipos = newListOfEquipos;
    filterListEquipo = [...equipos];
    notifyListeners();
  }
  setInspeccion( List<Inspeccion> newList){
    inspeccionList=newList;
    notifyListeners();
  }
  setFilterList( List<Inspeccion> newList){
    filterInspeccionList = newList;
    notifyListeners();
  }

  setFilterMovList(List<Movimiento> newList){
    filterMovimientoList = newList;
    notifyListeners();
  }

  setImgList( List<ModeloImg> newList){
    imgList=newList;
    notifyListeners();
  }

  setFilter(List<Equipo> newListOfEquipos){
    filterListEquipo = newListOfEquipos;
    notifyListeners();
  }
   initState(context) async{
    loading = true;
    equipos = await EquipoRepository().get(false);

    filterListEquipo = [...equipos];
    loading=false;
    inspeccionList = await InspeccionRepository().get(false);
    filterInspeccionList = [...inspeccionList];
    imgList = await ImgRepository().get(false);
    listCola = await ColaRepository().get();
    movimientos = await MovimientoRepository().get(false);
    clientes = await ClienteRepository().get(false);
    notifyListeners();
    contextMain= context;
    return loading;
  }

  void setMovimientoList(List<Movimiento> list) {
    movimientos = list;
    notifyListeners();
  }
}