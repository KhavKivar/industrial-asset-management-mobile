import 'dart:convert';

import 'package:app_licman/model/cliente.dart';
import 'package:http/http.dart' as http;

import '../const/Strings.dart';

Future<bool> loginViaToken(user, token) async {
  bool result = false;
  final client = http.Client();
  try {
    final response = await client.post(Uri.parse(Strings.urlServerLogin),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nombre': user,
          'token': token,
        }));

    final resultado = json.decode(response.body);
    if (response.statusCode == 200) {
      print(resultado.toString());
      if (resultado['message'] == 'Login Success') {
        result = true;
      }
    }
  } catch (e) {
    print("error $e");
  }
  return result;
}

Future<Map<String, dynamic>> loginApi(user, password) async {
  Map<String, dynamic> map = {};
  final client = http.Client();
  try {
    final response = await client.post(Uri.parse(Strings.urlServerLogin),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nombre': user,
          'password': password,
        }));
    print(response.body.toString());

    if (response.statusCode == 200) {
      map = json.decode(response.body);
      if (map['message'] == "Login Success") {
        map['status'] = "success";
      } else {
        map['status'] = "Contraseña incorrecta";
      }
    } else {
      map['status'] = "El usuario no existe";
    }
  } catch (e) {
    print("error ${e}");
    map['status'] = "error";
  }
  return map;
}
