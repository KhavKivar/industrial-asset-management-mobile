import 'dart:convert';
import 'dart:developer';

import 'package:app_licman/const/Strings.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/modeloimagen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Equipo>> getEquipos() async {
  List<Equipo> listado = [];
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse(Strings.urlServerGetEquipos));

    if (response.statusCode == 200) {

      listado = (json.decode(response.body) as List)
          .map((i) => Equipo.fromJson(i))
          .toList();
    }
  } catch (e) {
    print("error ${e}");

    listado = [];
  }
  return listado;
}

Future<List<Inspeccion>> getInspecciones() async {
  List<Inspeccion> listado = [];
  final client = http.Client();
  try {
    final response =
        await client.get(Uri.parse(Strings.urlServerGetInspecciones));

    listado = (json.decode(response.body) as List)
        .map((i) => Inspeccion.fromJson(i))
        .toList();
  } catch (e) {
    print(e);
  }

  return listado;
}

Future<List<ModeloImg>> getImgList() async {
  List<ModeloImg> listado = [];
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse(Strings.urlServerGetImg));
    log(response.body);
    listado = modeloImgFromJson(response.body);
  } catch (e) {
    print(e);
  }

  return listado;
}
