import 'package:app_licman/model/editCliente.dart';
import 'package:hive/hive.dart';

import '../model/cliente.dart';
import '../model/equipo.dart';
import '../model/inspeccion.dart';
import '../model/modeloimagen.dart';
import '../model/movimiento.dart';
import '../model/updateTime.dart';

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
  if (T == UpdateTime) {
    return (object as UpdateTime).updateTime;
  }
}

class HiveService {
  isExists<T>({required String boxName}) async {
    final openBox = await Hive.openBox<T>(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    print("adding boxes $T length ${items.length}");
    final openBox = await Hive.openBox<T>(boxName);
    for (var item in items) {
      openBox.add(item);
    }
  }

  addOneBox<T>(T item, String boxName) async {
    print("adding one box $boxName");
    final openBox = await Hive.openBox<T>(boxName);
    openBox.add(item);
  }

  removeBoxes<T>(String boxName) async {
    final openBox = await Hive.openBox<T>(boxName);
    await openBox.clear();
  }

  getBox<T>(String boxName) async {
    final openBox = await Hive.openBox<T>(boxName);
    return openBox.getAt(0);
  }

  getBoxes<T>(String boxName) async {
    List<T> boxList = List<T>.empty(growable: true);
    final openBox = await Hive.openBox<T>(boxName);
    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i) as T);
    }
    return boxList;
  }

  saveObject<T>(T item, String boxName) async {
    print("Saving object type $T to box $boxName");
    await addOneBox<T>(item, boxName);
  }

  deleteObject<T extends HiveObject>(dynamic id, String boxName) async {
    List<T> items = await getBoxes<T>(boxName);
    int index = items.indexWhere((x) => getIds(x) == id);
    if (index >= 0) {
      items[index].delete();
    }
  }

  editObject<T extends HiveObject>(T item, String boxName) async {
    List<T> items = await getBoxes<T>(boxName);
    int index = items.indexWhere((x) => getIds(x) == getIds(item));
    if (index >= 0) {
      T oldItem = items[index];
      callCopyWith<T>(oldItem, item);
    }
  }

  editClienteObject(EditCliente editCliente, boxName) async {
    List<Cliente> items = await getBoxes<Cliente>(boxName);
    int index = items.indexWhere((x) => getIds(x) == editCliente.oldRut);
    if (index >= 0) {
      Cliente oldItem = items[index];
      callCopyWith<Cliente>(oldItem, editCliente.cliente);
    }
  }
}
