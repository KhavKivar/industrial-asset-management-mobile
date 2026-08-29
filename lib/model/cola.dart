import 'dart:typed_data';

import 'package:industrial_asset_management_mobile/model/inspeccion.dart';
import 'package:hive/hive.dart';
part 'cola.g.dart';

@HiveType(typeId: 4)
class Cola extends HiveObject{
  @HiveField(0)
  Inspeccion? acta;
  @HiveField(1)
  String ts = "";
  @HiveField(2)
  String status = "WAITING";
  @HiveField(3)
  Uint8List? data;




  Cola(this.acta, this.ts, this.status,this.data);
}