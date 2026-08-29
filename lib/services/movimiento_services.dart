import 'dart:convert';

import 'package:industrial_asset_management_mobile/model/movimiento.dart';
import 'package:http/http.dart' as http;

import '../const/Strings.dart';

Future<List<Movimiento>> getMovimientos() async {
  List<Movimiento> listado = [];
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse(Strings.urlServerGetMovimientos));
    if (response.statusCode == 200) {
      listado = movimientoFromJson(response.body);
    }
  } catch (e) {
    print(e);
    listado = [];
  }
  return listado;
}
