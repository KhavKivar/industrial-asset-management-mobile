import 'package:app_licman/model/editCliente.dart';
import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/services/inventario/equiposServices.dart';
import 'package:flutter/material.dart';

import '../../repository/Img_repository.dart';
import '../../repository/Inspeccion_repository.dart';
import '../../repository/cliente_repository.dart';
import '../../repository/cola_repository.dart';
import '../../repository/equipo_repository.dart';
import '../../repository/movimientos_repository.dart';
import '../cliente.dart';
import '../cola.dart';
import '../equipo.dart';
import '../inspeccion.dart';
import '../modeloimagen.dart';

class AppState extends ChangeNotifier {
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

  //Socket Func

  //Equipos services
  addEquipo(Equipo equipo) {
    equipos.insert(0, equipo);
    filterListEquipo.insert(0, equipo);
    //Save in local bd
    EquipoRepository().saveEquipo(equipo);
    notifyListeners();
  }

  removeEquipo(int id) {
    int index = equipos.indexWhere((element) => element.id == id);
    if (index >= 0) {
      equipos.removeAt(index);
      //Remove from cache
      EquipoRepository().removeEquipo(id);
      int filterIndex =
          filterListEquipo.indexWhere((element) => element.id == id);
      if (filterIndex >= 0) {
        filterListEquipo.removeAt(filterIndex);
      }
      notifyListeners();
    }
  }

  editEquipo(Equipo equipo) {
    int index = equipos.indexWhere((element) => element.id == equipo.id);
    if (index >= 0) {
      //Obtain equipo from cache

      //Update cache
      EquipoRepository().editSave(equipo);

      //

      equipos[index] = equipo;
      int indexFilter =
          filterListEquipo.indexWhere((element) => element.id == equipo.id);
      bool existInFilter = indexFilter >= 0;
      if (existInFilter) {
        filterListEquipo[indexFilter] = equipo;
      }

      notifyListeners();
    }
  }

  //Actas Services;
  addActaSocket(Inspeccion acta) {
    inspeccionList.insert(0, acta);
    bool existInFilter = (filterInspeccionList.indexWhere(
            (element) => element.idInspeccion == acta.idInspeccion) !=
        -1);
    if (!existInFilter) {
      filterInspeccionList.insert(0, acta);
    }

    //Save in local bd
    InspeccionRepository().save(acta);
    notifyListeners();
  }

  editActaSocket(Inspeccion inspeccion) {
    int index = inspeccionList.indexWhere(
        (element) => element.idInspeccion == inspeccion.idInspeccion);
    if (index >= 0) {
      //Obtain acta from cache

      //Update cache
      InspeccionRepository().edit(inspeccion);

      //

      inspeccionList[index] = inspeccion;
      int indexFilter = filterInspeccionList.indexWhere(
          (element) => element.idInspeccion == inspeccion.idInspeccion);
      bool existInFilter = indexFilter >= 0;
      if (existInFilter) {
        filterInspeccionList[indexFilter] = inspeccion;
      }

      notifyListeners();
    }
  }

  removeActaSocket(int id) {
    int index =
        inspeccionList.indexWhere((element) => element.idInspeccion == id);
    if (index >= 0) {
      //Remove in cache

      InspeccionRepository().delete(id);

      inspeccionList.removeAt(index);
      int filterIndex = filterInspeccionList
          .indexWhere((element) => element.idInspeccion == id);
      if (filterIndex >= 0) {
        filterInspeccionList.removeAt(filterIndex);
      }
      notifyListeners();
    }
  }

  updateClienteInMovimiento(EditCliente editCliente) {
    for (int i = 0; i < movimientos.length; i++) {
      if (movimientos[i].rut == editCliente.oldRut) {
        movimientos[i].rut = editCliente.cliente.rut;
        movimientos[i].nombreCliente = editCliente.cliente.rut;
      }
    }
    for (int j = 0; j < filterMovimientoList.length; j++) {
      if (filterMovimientoList[j].rut == editCliente.oldRut) {
        filterMovimientoList[j].rut = editCliente.cliente.rut;
        filterMovimientoList[j].nombreCliente = editCliente.cliente.nombre;
      }
    }
  }
  //Clientes services

  addClienteSocket(Cliente cliente) {
    clientes.insert(0, cliente);
    //Save in local bd
    ClienteRepository().save(cliente);
    notifyListeners();
  }

  updateRutFromCliente(EditCliente editCliente) {
    int index =
        clientes.indexWhere((element) => element.rut == editCliente.oldRut);
    if (index >= 0) {
      clientes[index].rut == editCliente.cliente.rut;
      clientes[index].nombre = editCliente.cliente.nombre;

      ClienteRepository().edit(editCliente);

      updateClienteInMovimiento(editCliente);

      notifyListeners();
    }
  }

  removeClienteSocket(String rut) {
    int index = clientes.indexWhere((element) => element.rut.toString() == rut);
    if (index >= 0) {
      //Remove in cache
      ClienteRepository().delete(rut);

      clientes.removeAt(index);
      notifyListeners();
    }
  }

  //Movimientos
  Movimiento addClienteAndCodigoInterno(Movimiento movimiento) {
    int indexInspeccion = inspeccionList.indexWhere(
        (element) => element.idInspeccion == movimiento.idInspeccion);
    if (indexInspeccion >= 0) {
      movimiento.equipoId = inspeccionList[indexInspeccion].idEquipo.toString();
    } else {
      movimiento.equipoId = "";
    }
    int indexCliente = clientes
        .indexWhere((element) => element.rut == movimiento.rut.toString());
    if (indexCliente >= 0) {
      movimiento.nombreCliente = clientes[indexCliente].nombre;
    } else {
      movimiento.nombreCliente = "";
    }
    return movimiento;
  }

  addMovimientoSocket(Movimiento movimiento) {
    //Add Cliente y data;
    final movimientoFinal = addClienteAndCodigoInterno(movimiento);

    movimientos.insert(0, movimientoFinal);
    bool existInFilter = filterMovimientoList.indexWhere((element) =>
            element.idMovimiento == movimientoFinal.idMovimiento) !=
        -1;
    if (!existInFilter) {
      filterMovimientoList.insert(0, movimientoFinal);
    }

    MovimientoRepository().save(movimientoFinal);
    notifyListeners();
  }

  editMovimientoSocket(Movimiento movimiento) {
    int index = movimientos.indexWhere(
        (element) => element.idMovimiento == movimiento.idMovimiento);
    final movimientoFinal = addClienteAndCodigoInterno(movimiento);
    if (index >= 0) {
      //Update cache
      MovimientoRepository().edit(movimiento);

      movimientos[index] = movimientoFinal;
      int indexFilter = filterMovimientoList.indexWhere(
          (element) => element.idMovimiento == movimiento.idMovimiento);
      bool existInFilter = indexFilter >= 0;
      if (existInFilter) {
        filterMovimientoList[indexFilter] = movimientoFinal;
      }
      notifyListeners();
    }
  }

  removeMovimientoSocket(int id) {
    int index = movimientos.indexWhere((element) => element.idMovimiento == id);
    if (index >= 0) {
      //Remove in cache
      MovimientoRepository().delete(id);

      movimientos.removeAt(index);
      int filterIndex = filterMovimientoList
          .indexWhere((element) => element.idMovimiento == id);
      if (filterIndex >= 0) {
        filterMovimientoList.removeAt(filterIndex);
      }
      notifyListeners();
    }
  }

  //Img
  addModeloSocket(ModeloImg modeloImg) {
    imgList.insert(0, modeloImg);
    ImgRepository().save(modeloImg);
    notifyListeners();
  }

  editModeloSocket(ModeloImg modeloImg) {
    int index =
        imgList.indexWhere((element) => element.modelo == modeloImg.modelo);
    if (index >= 0) {
      //Update cache
      ImgRepository().edit(modeloImg);

      imgList[index] = modeloImg;
      notifyListeners();
    }
  }

  removeModeloSocket(String modelo) {
    int index = imgList.indexWhere((element) => element.modelo == modelo);
    if (index >= 0) {
      //Remove in cache
      ImgRepository().delete(modelo);

      imgList.removeAt(index);
      notifyListeners();
    }
  }

  //
  //
  //

  addColumnsToMov() {
    for (int i = 0; i < movimientos.length; i++) {
      movimientos[i].equipoId = inspeccionList
          .firstWhere(
              (element) => element.idInspeccion == movimientos[i].idInspeccion)
          .idEquipo
          .toString();
      movimientos[i].nombreCliente = clientes
          .firstWhere((element) =>
              element.rut.toString() == movimientos[i].rut.toString())
          .nombre
          .toString();
    }
  }

  setClientes(List<Cliente> n_clientes) {
    clientes = n_clientes;
    notifyListeners();
  }

  setSearchMovText(String text) {
    searchMovText = text;
    notifyListeners();
  }

  setIndexCola(int index) {
    indexCola = index;
  }

  setSearchActa(String text) {
    searchActasText = text;
    notifyListeners();
  }

  bool loading = false;
  addActa(Inspeccion acta) {
    inspeccionList.insert(0, acta);
    filterInspeccionList.insert(0, acta);
    notifyListeners();
  }

  setActa(Inspeccion acta) {
    int index = inspeccionList
        .indexWhere((element) => element.idInspeccion == acta.idInspeccion);
    print(" index ${index}");
    if (index != -1) {
      print(" Modificar");
      inspeccionList[index] = acta;
      final indexFiltro = filterInspeccionList
          .indexWhere((element) => element.idInspeccion == acta.idInspeccion);
      if (indexFiltro != -1) {
        filterInspeccionList[indexFiltro] = acta;
      }
    }
    notifyListeners();
  }

  removeCola(Cola cola) {
    int indexCola = listCola.indexWhere((element) => element.data == cola.data);
    if (indexCola != -1) {
      print(indexCola);
      listCola.removeAt(indexCola);
    }
    notifyListeners();
  }

  addCola(Cola cola) {
    listCola.add(cola);
    notifyListeners();
  }

  getEquipo() {
    return equipos;
  }

  setHorometro(int idEquipo, double hor) {
    int indexEquipo =
        equipos.lastIndexWhere((element) => element.id == idEquipo);
    if (equipos[indexEquipo].horometro < hor) {
      equipos[indexEquipo].horometro = hor;
    }
    filterListEquipo = [...equipos];
    notifyListeners();
  }

  setEquipo(List<Equipo> newListOfEquipos) {
    equipos = newListOfEquipos;
    filterListEquipo = [...equipos];
    notifyListeners();
  }

  setInspeccion(List<Inspeccion> newList) {
    inspeccionList = newList;
    notifyListeners();
  }

  setFilterList(List<Inspeccion> newList) {
    filterInspeccionList = newList;
    notifyListeners();
  }

  setFilterMovList(List<Movimiento> newList) {
    filterMovimientoList = newList;
    notifyListeners();
  }

  setImgList(List<ModeloImg> newList) {
    imgList = newList;
    notifyListeners();
  }

  setFilter(List<Equipo> newListOfEquipos) {
    filterListEquipo = newListOfEquipos;
    notifyListeners();
  }

  initState(context) async {
    loading = true;
    equipos = await EquipoRepository().get(false);

    filterListEquipo = [...equipos];
    loading = false;
    inspeccionList = await InspeccionRepository().get(false);
    filterInspeccionList = [...inspeccionList];
    imgList = await ImgRepository().get(false);
    listCola = await ColaRepository().get();
    movimientos = await MovimientoRepository().get(false);
    clientes = await ClienteRepository().get(false);
    notifyListeners();
    contextMain = context;
    return loading;
  }

  void setMovimientoList(List<Movimiento> list) {
    movimientos = list;
    notifyListeners();
  }
}
