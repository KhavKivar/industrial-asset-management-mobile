import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/equipo.dart';
import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/inventario/equiposServices.dart';
import '../services/util.dart';

class EquipoRepository {
  final HiveService hiveService = HiveService();

  Future<List<Equipo>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists(boxName: "Equipos");
    List<Equipo> equipos = [];

    if(exists && !forceUpdate){
      print("Cache equipos");
      var eq = await(hiveService.getBoxes('Equipos'));
      return List<Equipo>.from(eq);
    }else{
      equipos = await getEquipos();

      if(exists){
        hiveService.removeBoxes("Equipos").then((x) async {
          await hiveService.addBoxes(equipos, "Equipos");
        });
      }else{
        await hiveService.addBoxes(equipos, "Equipos");
      }

      bool cacheExist =  await hiveService.isExists(boxName: "cache_time_equipo");
      List<UpdateTime> updateList = await getLastUpdate();
      if(cacheExist){
        hiveService.removeBoxes("cache_time_equipo").then((x)async{
          UpdateTime timeEq = updateList[0];
          print(timeEq.updateTime.toString());
          await hiveService.addOneBox(timeEq,"cache_time_equipo");
        });
      }else{
        UpdateTime timeEq = updateList[0];
        print(timeEq.updateTime.toString());
        await hiveService.addOneBox(timeEq,"cache_time_equipo");
      }
    }
    return equipos;
  }
}
