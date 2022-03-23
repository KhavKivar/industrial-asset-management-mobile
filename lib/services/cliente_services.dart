import 'dart:convert';

import 'package:app_licman/model/cliente.dart';
import 'package:http/http.dart' as http;

import '../const/Strings.dart';


Future<List<Cliente>> getClientes() async {
   List<Cliente> listado = [];
   final client = http.Client();
   try {
     final response = await client.get(Uri.parse(Strings.urlServerGetClientes));

     if (response.statusCode == 200) {

       listado = (json.decode(response.body) as List)
           .map((i) => Cliente.fromJson(i))
           .toList();
     }
   } catch (e) {
     print("error ${e}");

     listado = [];
   }
   return listado;
}