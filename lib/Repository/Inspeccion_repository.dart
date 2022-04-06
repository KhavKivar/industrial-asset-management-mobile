import 'package:app_licman/services/inventario/equiposServices.dart';
import 'package:hive/hive.dart';

import '../model/inspeccion.dart';
import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/util.dart';

class InspeccionRepository{
  final HiveService hiveService = HiveService();


  Future<List<Inspeccion>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists(boxName: "ACTA");
    List<Inspeccion> actas = [];



    if(exists && !forceUpdate){
      print("Cache actas");
      var eq = await(hiveService.getBoxes('ACTA'));
      return List<Inspeccion>.from(eq);
    }else{
      actas = await getInspecciones();
      print(actas.length);
      if(exists){
        hiveService.removeBoxes("ACTA").then((x) async {
          await hiveService.addBoxes(actas, "ACTA");
        });
      }else{

        await hiveService.addBoxes(actas, "ACTA");
      }

      bool cacheExist =  await hiveService.isExists(boxName: "cache_time_acta");
      List<UpdateTime> updateList = await getLastUpdate();
      if(cacheExist){
        hiveService.removeBoxes("cache_time_acta").then((x)async{
          UpdateTime timeEq = updateList[1];
          await hiveService.addOneBox(timeEq,"cache_time_acta");
        });
      }else{

        UpdateTime timeEq = updateList[1];
        await hiveService.addOneBox(timeEq,"cache_time_acta");
      }


    }

    return actas;
  }


}