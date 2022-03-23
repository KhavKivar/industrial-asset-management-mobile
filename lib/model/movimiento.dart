// To parse this JSON data, do
//
//     final movimiento = movimientoFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
part 'movimiento.g.dart';

List<Movimiento> movimientoFromJson(String str) => List<Movimiento>.from(json.decode(str).map((x) => Movimiento.fromJson(x)));

String movimientoToJson(List<Movimiento> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 5)
class Movimiento extends HiveObject{
  Movimiento({
    required this.idMovimiento,
    required this.transporte,
    required this.fechaRetiro,
    required this.fechaMov,
    required this.idInspeccion,
    required this.rut,
    required this.idGuiaDespacho,
    required this.urlGuiaDespacho,
    required this.cambio,
    required this.tipo,
    required this.observaciones,
  });
  @HiveField(0)
  int idMovimiento;
  @HiveField(1)
  String transporte;
  @HiveField(2)
  DateTime? fechaRetiro;
  @HiveField(3)
  DateTime fechaMov;
  @HiveField(4)
  int idInspeccion;
  @HiveField(5)
  String rut;
  @HiveField(6)
  int idGuiaDespacho;
  @HiveField(7)
  String urlGuiaDespacho;
  @HiveField(8)
  int? cambio;
  @HiveField(9)
  String tipo;
  @HiveField(10)
  String observaciones;

  String? equipoId;
  String nombreCliente = "";

  factory Movimiento.fromJson(Map<String, dynamic> json) => Movimiento(
    idMovimiento: json["idMovimiento"],
    transporte: json["transporte"],
    fechaRetiro: json['fechaRetiro'] ==null ? null:DateTime.parse(json["fechaRetiro"]),
    fechaMov: DateTime.parse(json["fechaMov"]),
    idInspeccion: json["idInspeccion"],
    rut: json["rut"],
    idGuiaDespacho: json["idGuiaDespacho"],
    urlGuiaDespacho: json["urlGuiaDespacho"],
    cambio: json["cambio"] == null ?  null:json['cambio'],
    tipo: json["tipo"],
    observaciones: json["observaciones"],
  );

  Map<String, dynamic> toJson() => {
    "idMovimiento": idMovimiento,
    "transporte": transporte,
    "fechaRetiro": fechaRetiro?.toIso8601String(),
    "fechaMov": fechaMov.toIso8601String(),
    "idInspeccion": idInspeccion,
    "rut": rut,
    "idGuiaDespacho": idGuiaDespacho,
    "urlGuiaDespacho": urlGuiaDespacho,
    "cambio": cambio,
    "tipo": tipo,
    "observaciones": observaciones,
  };
}
