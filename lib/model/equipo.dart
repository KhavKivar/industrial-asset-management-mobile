// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';
part 'equipo.g.dart';

List<Equipo> welcomeFromJson(String str) => List<Equipo>.from(json.decode(str).map((x) => Equipo.fromJson(x)));

String welcomeToJson(List<Equipo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


@HiveType(typeId: 0)
class Equipo extends HiveObject{
  Equipo({
    required this.id,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.serie,
    required this.capacidad,
    required this.mastil,
    required this.altura,
    required this.ano,
    required this.horometro,
    required this.precioNeto,
    required this.estado,
    required this.ubicacion
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String tipo;

  @HiveField(2)
  String marca;

  @HiveField(3)
  String modelo;

  @HiveField(4)
  String serie;

  @HiveField(5)
  int capacidad = 0;

  @HiveField(6)
  String mastil = "";

  @HiveField(7)
  double altura = 0.0;

  @HiveField(8)
  String ano;

  @HiveField(9)
  double horometro;


  @HiveField(10)
  String estado;

  @HiveField(11)
  String ubicacion;

  @HiveField(12)
  int precioNeto;


  factory Equipo.fromJson(Map<String, dynamic> json) => Equipo(
    id: json["idEquipo"],
    tipo: json["tipo"],
    marca: json["marca"],
    modelo: json["modelo"],
    serie: json["serie"],
    capacidad: json["capacidad"],
    mastil: json["mastil"] == null ?  "":json["mastil"] ,
    altura:  json["altura"] == null ? 0.0 : json["altura"].toDouble(),
    ano: json["ano"],
    horometro: json["horometro"] == null ? 0.0 : json["horometro"].toDouble(),
    estado: json['estado'],
    ubicacion: json['ubicacion'],
    precioNeto: json["precio_neto"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tipo": tipo,
    "marca": marca,
    "modelo": modelo,
    "serie": serie,
    "capacidad": capacidad,
    "mastil": mastil,
    "altura": altura,
    "ano": ano,
    "horometro": horometro,
     "estado":estado,
    "ubicacion":ubicacion,
    "precio_neto": precioNeto,
  };
}
