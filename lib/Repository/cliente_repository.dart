import 'dart:io';

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

  Future<List<Cliente>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists(boxName: "Clientes");
    List<Cliente> Clientes = [];

    if (exists && !forceUpdate) {
      print("Cache Clientes");
      var eq = await (hiveService.getBoxes('Clientes'));
      return List<Cliente>.from(eq);
    } else {
      Clientes = await getClientes();

      if (exists) {
        updateCachUltraFast<Cliente>('Clientes', Clientes);
      } else {
        await hiveService.addBoxes(Clientes, "Clientes");
      }

      bool cacheExist =
          await hiveService.isExists(boxName: "cache_time_cliente");
      List<UpdateTime> updateList = await getLastUpdate();
      if (cacheExist) {
        hiveService.removeBoxes("cache_time_cliente").then((x) async {
          UpdateTime timeEq = updateList[4];
          print(timeEq.updateTime.toString());
          await hiveService.addOneBox(timeEq, "cache_time_cliente");
        });
      } else {
        UpdateTime timeEq = updateList[4];
        print(timeEq.updateTime.toString());
        await hiveService.addOneBox(timeEq, "cache_time_cliente");
      }
    }
    return Clientes;
  }
}
