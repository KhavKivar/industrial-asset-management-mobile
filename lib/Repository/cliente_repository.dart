import 'dart:io';

import 'package:app_licman/model/editCliente.dart';
import 'package:app_licman/repository/utils.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/cliente.dart';
import '../model/updateTime.dart';
import '../services/cliente_services.dart';
import '../services/hive_services.dart';

import '../services/util.dart';

class ClienteRepository {
  final HiveService hiveService = HiveService();
  final String boxName = 'Clientes';
  final String boxCacheName = 'cache_time_cliente';

  delete(String rut) async {
    await hiveService.deleteObject<Cliente>(rut, boxName);
  }

  edit(EditCliente editCliente) async {
    await hiveService.editClienteObject(editCliente, boxName);
  }

  save(Cliente cliente) {
    hiveService.addOneBox<Cliente>(cliente, boxName);
  }

  Future<List<Cliente>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists<Cliente>(boxName: boxName);
    List<Cliente> clientes = [];

    if (exists && !forceUpdate) {
      print("Cache Clientes");
      clientes = await hiveService.getBoxes<Cliente>(boxName);
      return clientes;
    } else {
      clientes = await getClientes();
      if (exists) {
        updateCacheUltraFast<Cliente>(boxName, clientes);
      } else {
        await hiveService.addBoxes<Cliente>(clientes, boxName);
      }

      bool cacheExist =
          await hiveService.isExists<UpdateTime>(boxName: boxCacheName);
      List<UpdateTime> updateList = await getLastUpdate();
      if (updateList.isNotEmpty) {
        if (cacheExist) {
          hiveService.removeBoxes<UpdateTime>(boxCacheName).then((x) async {
            UpdateTime timeEq = updateList[4];
            await hiveService.addOneBox<UpdateTime>(timeEq, boxCacheName);
          });
        } else {
          UpdateTime timeEq = updateList[4];
          await hiveService.addOneBox<UpdateTime>(timeEq, boxCacheName);
        }
      }
    }
    return clientes;
  }
}
