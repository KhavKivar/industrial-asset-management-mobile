import 'dart:io';

import 'package:app_licman/repository/utils.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/equipo.dart';
import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/inventario/equiposServices.dart';
import '../services/util.dart';

class EquipoRepository {
  final HiveService hiveService = HiveService();
  final String boxName = 'Equipos';
  final String boxCacheName = 'cache_time_equipo';

  editSave(Equipo equipo) async {
    await hiveService.editObject<Equipo>(equipo, boxName);
  }

  removeEquipo(int id) async {
    await hiveService.deleteObject<Equipo>(id, boxName);
  }

  saveEquipo(Equipo equipo) async {
    await hiveService.addOneBox<Equipo>(equipo, boxName);
  }

  Future<List<Equipo>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists<Equipo>(boxName: boxName);
    List<Equipo> equipos = [];

    if (exists && !forceUpdate) {
      print("Cache equipos");
      equipos = await hiveService.getBoxes<Equipo>(boxName);
      equipos.sort((a, b) => a.id.compareTo(b.id));
      return equipos;
    } else {
      equipos = await getEquipos();
      if (exists) {
        updateCacheUltraFast<Equipo>(boxName, equipos);
      } else {
        await hiveService.addBoxes<Equipo>(equipos, boxName);
      }
      bool cacheExist =
          await hiveService.isExists<UpdateTime>(boxName: boxCacheName);
      List<UpdateTime> updateList = await getLastUpdate();
      if (updateList.isNotEmpty) {
        if (cacheExist) {
          hiveService.removeBoxes<UpdateTime>(boxCacheName).then((x) async {
            UpdateTime timeEq = updateList[0];
            await hiveService.addOneBox<UpdateTime>(timeEq, boxCacheName);
          });
        } else {
          UpdateTime timeEq = updateList[0];
          await hiveService.addOneBox<UpdateTime>(timeEq, boxCacheName);
        }
      }
    }
    return equipos;
  }
}
