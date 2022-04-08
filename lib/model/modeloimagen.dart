import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'modeloimagen.g.dart';

List<ModeloImg> modeloImgFromJson(String str) =>
    List<ModeloImg>.from(json.decode(str).map((x) => ModeloImg.fromJson(x)));

String modeloImgToJson(List<ModeloImg> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 1)
class ModeloImg extends HiveObject with EquatableMixin {
  ModeloImg({
    required this.modelo,
    required this.url,
  });
  @HiveField(0)
  String modelo;
  @HiveField(1)
  String url;

  factory ModeloImg.fromJson(Map<String, dynamic> json) => ModeloImg(
        modelo: json["modelo"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "modelo": modelo,
        "url": url,
      };
  copyWith(ModeloImg modeloImg) {
    modelo = modeloImg.modelo;
    url = modeloImg.url;
  }

  @override
  // TODO: implement props
  List<Object?> get props {
    return [modelo, url];
  }
}
