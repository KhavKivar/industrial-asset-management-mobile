import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/movimiento.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../model/cliente.dart';
import '../model/inspeccion.dart';
import '../model/modeloimagen.dart';
import '../services/hive_services.dart';

getIds<T>(T object) {
  if (T == Inspeccion) {
    return (object as Inspeccion).idInspeccion.toString();
  }
  if (T == Movimiento) {
    return (object as Movimiento).idMovimiento.toString();
  }
  if (T == Equipo) {
    return (object as Equipo).id.toString();
  }
  if (T == Cliente) {
    return (object as Cliente).rut.toString();
  }
  if (T == ModeloImg) {
    return (object as ModeloImg).modelo.toString();
  }
}

compareTwoItem<T>(T item1, T item2) {
  if (T == Inspeccion) {
    return (item1 as Inspeccion).idInspeccion ==
        (item2 as Inspeccion).idInspeccion;
  }
  if (T == Movimiento) {
    return (item1 as Movimiento).idMovimiento ==
        (item2 as Movimiento).idMovimiento;
  }
  if (T == Equipo) {
    return (item1 as Equipo).id == (item2 as Equipo).id;
  }
  if (T == Cliente) {
    return (item1 as Cliente).rut == (item2 as Cliente).rut;
  }
  if (T == ModeloImg) {
    return (item1 as ModeloImg).modelo == (item2 as ModeloImg).modelo;
  }
}

callCopyWith<T extends HiveObject>(T item1, T item2) {
  if (T == Inspeccion) {
    (item1 as Inspeccion).copyWith(item2 as Inspeccion);
    item1.save();
  }
  if (T == Movimiento) {
    (item1 as Movimiento).copyWith(item2 as Movimiento);
    item1.save();
  }
  if (T == Equipo) {
    (item1 as Equipo).copyWith(item2 as Equipo);
    item1.save();
  }
  if (T == Cliente) {
    (item1 as Cliente).copyWith(item2 as Cliente);
    item1.save();
  }
  if (T == ModeloImg) {
    (item1 as ModeloImg).copyWith(item2 as ModeloImg);
    item1.save();
  }
}

updateCacheUltraFast<T extends HiveObject>(
    String cache, List<T> listToUpdate) async {
  final HiveService hiveService = HiveService();
  Set<String> setPrevActaCacheIds = {};
  Set<String> setNewActaCacheIds = {};
  if (kDebugMode) {
    print("Cache $cache -- Ultra fast");
  }

  List<T> prevItemCache = await hiveService.getBoxes<T>(cache);
  for (var element in prevItemCache) {
    setPrevActaCacheIds.add(getIds<T>(element));
  }
  for (var element1 in listToUpdate) {
    setNewActaCacheIds.add(getIds<T>(element1));
  }
  print(
      "prev: ${setPrevActaCacheIds.length} now: ${setNewActaCacheIds.length}");

  //update
  for (int i = 0; i < prevItemCache.length; i++) {
    int index = listToUpdate
        .indexWhere((element) => compareTwoItem(element, prevItemCache[i]));
    if (index >= 0) {
      if (prevItemCache[i] != listToUpdate[index]) {
        print("element not equal ${getIds<T>(prevItemCache[i])}");
        callCopyWith(prevItemCache[i], listToUpdate[index]);
      }
    }
  }
  //add
  final Set<String> bMinusA =
      setNewActaCacheIds.difference(setPrevActaCacheIds);

  print("to add ${bMinusA.length}");
  //var actasCacheList = await Hive.openBox<T>(cache);

  for (int i = 0; i < bMinusA.length; i++) {
    int index = listToUpdate
        .indexWhere((element) => getIds<T>(element) == bMinusA.elementAt(i));
    if (index >= 0) {
      print("add ${getIds<T>(listToUpdate[index])}");
      hiveService.addOneBox<T>(listToUpdate[index], cache);
      //actasCacheList.add(listToUpdate[index]);
    }
  }

  //remove
  final Set<String> aMinusB =
      setPrevActaCacheIds.difference(setNewActaCacheIds);
  print("to remove ${aMinusB.length}");
  for (int i = 0; i < aMinusB.length; i++) {
    int index = prevItemCache
        .indexWhere((element) => getIds<T>(element) == aMinusB.elementAt(i));
    if (index >= 0) {
      print("remove ${getIds<T>(prevItemCache[index])}");

      prevItemCache[index].delete();
    }
  }
  print("Finish Process Cache $cache -- Ultra fast");
}
