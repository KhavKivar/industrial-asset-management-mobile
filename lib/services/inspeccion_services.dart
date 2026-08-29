import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:industrial_asset_management_mobile/const/Strings.dart';
import 'package:industrial_asset_management_mobile/model/equipo.dart';
import 'package:industrial_asset_management_mobile/model/inspeccion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Inspeccion?> sendActa(Inspeccion acta) async {
  final url = Uri.parse(Strings.urlServerPostInps);
  try {
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(acta.toJson()));
    if(response.statusCode == 200){
      return Inspeccion.fromJson(json.decode(response.body));
    }
    if(response.statusCode== 505){
      print("code 505");
      throw HttpException(jsonDecode(response.body)['sqlMessage']);
    }
  }on SocketException {
    throw SocketException('No Internet connection');
  }on HttpException catch(e){
    throw HttpException(e.toString());
  } catch(e){
    throw Exception(e);
  }
  return null;
}

Future<Inspeccion?> sendEditActa(Inspeccion acta) async {
  final url = Uri.parse(Strings.urlServerEditInps+acta.idInspeccion.toString());
  try {
    final response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(acta.toJson()));
    if(response.statusCode == 200){
      return Inspeccion.fromJson(json.decode(response.body));
    }
    if(response.statusCode== 505){
      print(response.body);
      throw HttpException(jsonDecode(response.body)['message']['sqlMessage']);
    }
  } on SocketException {
    throw SocketException('No Internet connection');
  } on HttpException catch(e){
    throw HttpException(e.toString());
  }catch(e){
    throw Exception(e);
  }
  return null;
}


class HttpException implements Exception {
  final String message;
  HttpException(this.message);  // Pass your message in constructor.
  @override
  String toString() {
    return message;
  }
}
