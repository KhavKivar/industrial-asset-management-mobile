import 'package:app_licman/repository/utils.dart';
import 'package:app_licman/services/inventario/equiposServices.dart';

import '../model/modeloimagen.dart';
import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/util.dart';

class ImgRepository {
  final HiveService hiveService = HiveService();
  final String boxName = "IMG";
  final String boxNameCache = "cache_time_img";

  delete(String modelo) async {
    await hiveService.deleteObject<ModeloImg>(modelo, boxName);
  }

  save(ModeloImg modeloImg) async {
    await hiveService.addOneBox<ModeloImg>(modeloImg, boxName);
  }

  edit(ModeloImg modeloImg) async {
    await hiveService.editObject<ModeloImg>(modeloImg, boxName);
  }

  Future<List<ModeloImg>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists<ModeloImg>(boxName: boxName);
    List<ModeloImg> imgs = [];

    if (exists && !forceUpdate) {
      print("Cache imagenes");
      imgs = await hiveService.getBoxes<ModeloImg>(boxName);
      return imgs;
    } else {
      imgs = await getImgList();
      if (exists) {
        updateCacheUltraFast<ModeloImg>(boxName, imgs);
      } else {
        await hiveService.addBoxes<ModeloImg>(imgs, boxName);
      }

      bool cacheExist =
          await hiveService.isExists<UpdateTime>(boxName: boxNameCache);
      List<UpdateTime> updateList = await getLastUpdate();
      if (updateList.isNotEmpty) {
        if (cacheExist) {
          hiveService.removeBoxes<UpdateTime>(boxNameCache).then((x) async {
            UpdateTime timeEq = updateList[2];
            await hiveService.addOneBox<UpdateTime>(timeEq, boxNameCache);
          });
        } else {
          UpdateTime timeEq = updateList[2];
          await hiveService.addOneBox<UpdateTime>(timeEq, boxNameCache);
        }
      }
    }

    return imgs;
  }
}
