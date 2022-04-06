import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/services/movimiento_services.dart';

import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/util.dart';

class MovimientoRepository{
    final HiveService hiveService = HiveService();
    Future<List<Movimiento>> get(bool forceUpdate) async {
      bool exists = await hiveService.isExists(boxName: "MOVIMIENTOS");
      List<Movimiento> movimientos = [];
      if(exists && !forceUpdate){
        print("Cache movimientos");
        var eq = await(hiveService.getBoxes('MOVIMIENTOS'));
        return List<Movimiento>.from(eq);
      }else{
        movimientos = await getMovimientos();
        print("get movimientos");
        if(exists){
          hiveService.removeBoxes("MOVIMIENTOS").then((x) async {
            print("here ${movimientos.length}");
            await hiveService.addBoxes(movimientos, "MOVIMIENTOS");
          });
        }else{
          print("SIN CACHE ${movimientos.length}");
          await hiveService.addBoxes(movimientos, "MOVIMIENTOS");
        }
        bool cacheExist =  await hiveService.isExists(boxName: "cache_time_movimiento");
        List<UpdateTime> updateList = await getLastUpdate();
        if(cacheExist){
          UpdateTime movCache = await hiveService.getBox("cache_time_movimiento");

          movCache.updateTime = updateList[3].updateTime;
          movCache.save();

        }else{
          UpdateTime timeEq = updateList[3];

          await hiveService.addOneBox(timeEq,"cache_time_movimiento");
        }
      }
      return movimientos;
    }
}