import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/repository/utils.dart';
import 'package:app_licman/services/movimiento_services.dart';

import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/util.dart';

class MovimientoRepository {
  final HiveService hiveService = HiveService();
  String boxName = "MOVIMIENTOS";
  String boxChacheName = "cache_time_movimiento";

  delete(int id) async {
    hiveService.deleteObject<Movimiento>(id, boxName);
  }

  edit(Movimiento movimiento) async {
    hiveService.editObject<Movimiento>(movimiento, boxName);
  }

  save(Movimiento movimiento) {
    hiveService.addOneBox<Movimiento>(movimiento, boxName);
  }

  Future<List<Movimiento>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists<Movimiento>(boxName: boxName);
    List<Movimiento> movimientos = [];
    if (exists && !forceUpdate) {
      print("Cache movimientos");
      List<Movimiento> movimientos =
          await hiveService.getBoxes<Movimiento>(boxName);
      return movimientos;
    } else {
      movimientos = await getMovimientos();
      if (exists) {
        updateCacheUltraFast<Movimiento>(boxName, movimientos);
      } else {
        await hiveService.addBoxes<Movimiento>(movimientos, boxName);
      }
      bool cacheExist =
          await hiveService.isExists<UpdateTime>(boxName: boxChacheName);
      List<UpdateTime> updateList = await getLastUpdate();

      if (updateList.isNotEmpty) {
        if (cacheExist) {
          UpdateTime movCache =
              await hiveService.getBox<UpdateTime>(boxChacheName);
          movCache.updateTime = updateList[3].updateTime;
          movCache.save();
        } else {
          UpdateTime timeEq = updateList[3];
          await hiveService.addOneBox<UpdateTime>(timeEq, boxChacheName);
        }
      }
    }
    return movimientos;
  }
}
