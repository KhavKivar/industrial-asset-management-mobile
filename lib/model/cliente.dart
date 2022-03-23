// To parse this JSON data, do
//
//     final cliente = clienteFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
part 'cliente.g.dart';

List<Cliente> clienteFromJson(String str) => List<Cliente>.from(json.decode(str).map((x) => Cliente.fromJson(x)));

String clienteToJson(List<Cliente> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


@HiveType(typeId: 10)
class Cliente extends HiveObject {
  Cliente({
    required this.rut,
    required this.nombre,
    required this.telefono,
  });
  @HiveField(0)
  String rut;
  @HiveField(1)
  String nombre;
  @HiveField(2)
  String telefono;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
    rut: json["rut"],
    nombre: json["nombre"],
    telefono: json["telefono"],
  );

  Map<String, dynamic> toJson() => {
    "rut": rut,
    "nombre": nombre,
    "telefono": telefono,
  };
}
