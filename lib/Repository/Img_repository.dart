import 'package:app_licman/services/inventario/equiposServices.dart';

import '../model/modeloimagen.dart';
import '../model/updateTime.dart';
import '../services/hive_services.dart';
import '../services/util.dart';

class ImgRepository{
  final HiveService hiveService = HiveService();

  Future<List<ModeloImg>> get(bool forceUpdate) async {
    bool exists = await hiveService.isExists(boxName: "IMG");
    List<ModeloImg> imgs = [];

    if(exists && !forceUpdate){
      print("Cache imagenes");
      var eq = await(hiveService.getBoxes('IMG'));
      return List<ModeloImg>.from(eq);
    }else{
      imgs = await getImgList();
      if(exists){
        hiveService.removeBoxes("IMG").then((x) async {
          await hiveService.addBoxes(imgs, "IMG");
        });
      }else{
        await hiveService.addBoxes(imgs, "IMG");
      }

      bool cacheExist =  await hiveService.isExists(boxName: "cache_time_img");
      List<UpdateTime> updateList = await getLastUpdate();
      if(cacheExist){
        hiveService.removeBoxes("cache_time_img").then((x)async{

          UpdateTime timeEq = updateList[2];
          await hiveService.addOneBox(timeEq,"cache_time_img");
        });
      }
      else{
        hiveService.removeBoxes("cache_time_img").then((x)async{

          UpdateTime timeEq = updateList[2];
          await hiveService.addOneBox(timeEq,"cache_time_img");
        });
      }


    }

    return imgs;
  }
}