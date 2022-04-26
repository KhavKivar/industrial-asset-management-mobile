import 'package:app_licman/repository/utils.dart';
import 'package:app_licman/services/inventario/equiposServices.dart';
import 'package:hive/hive.dart';

import '../model/inspeccion.dart';
import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/util.dart';

class InspeccionRepository {
  final HiveService hiveService = HiveService();
  String boxName = "ACTA";
  String boxTimeName = "cache_time_acta";

  delete(int id) async {
    hiveService.deleteObject<Inspeccion>(id, boxName);
  }

  save(Inspeccion inspeccion) async {
    hiveService.saveObject<Inspeccion>(inspeccion, boxName);
  }

  edit(Inspeccion inspeccion) async {
    hiveService.editObject<Inspeccion>(inspeccion, boxName);
  }

  Future<List<Inspeccion>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists<Inspeccion>(boxName: boxName);
    List<Inspeccion> actas = [];

    if (exists && !forceUpdate) {
      actas = await hiveService.getBoxes<Inspeccion>(boxName);
      actas.sort(((a, b) => b.idInspeccion!.compareTo(a.idInspeccion!)));

      print("Cache actas ${actas.length}");
      return actas;
    } else {
      actas = await getInspecciones();
      if (exists) {
        updateCacheUltraFast<Inspeccion>(boxName, actas);
      } else {
        await hiveService.addBoxes<Inspeccion>(actas, boxName);
      }
      bool cacheExist =
          await hiveService.isExists<UpdateTime>(boxName: boxTimeName);
      List<UpdateTime> updateList = await getLastUpdate();
      if (updateList.isNotEmpty) {
        if (cacheExist) {
          hiveService.removeBoxes<UpdateTime>(boxTimeName).then((x) async {
            UpdateTime timeEq = updateList[1];
            await hiveService.addOneBox<UpdateTime>(timeEq, boxTimeName);
          });
        } else {
          UpdateTime timeEq = updateList[1];
          await hiveService.addOneBox<UpdateTime>(timeEq, boxTimeName);
        }
      }
    }

    return actas;
  }
}
