
import 'package:hive/hive.dart';

class HiveService {
  isExists({required String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    print("adding boxes");
    final openBox = await Hive.openBox(boxName);
    for (var item in items) {
      openBox.add(item);
    }
  }
  addOneBox(item, String boxName) async {
    print("adding one box");
    final openBox = await Hive.openBox(boxName);
    openBox.add(item);

  }


  removeBoxes(String BoxName)async{
    await Hive.box(BoxName).clear();

  }

  getBox(String boxName)async{
    final openBox = await Hive.openBox(boxName);
    return openBox.getAt(0);
  }

  getBoxes<T>(String boxName) async {
    List<T> boxList = List<T>.empty(growable: true);
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }
}