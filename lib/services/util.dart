import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:industrial_asset_management_mobile/model/updateTime.dart';

import '../const/Strings.dart';
import 'package:http/http.dart' as http;

Future<List<UpdateTime>> getLastUpdate() async {
  final url = Uri.parse(Strings.urlServerGetUpdateState);
  List<UpdateTime> listUpdate = [];

  try {
    final response = await http.get(url);

    listUpdate = updateTimeFromJson(response.body);
    return listUpdate ;
  } catch (e) {
    print(e);
    return listUpdate;
  }
}

 checkConnectivity() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}
