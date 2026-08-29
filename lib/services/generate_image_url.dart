
import 'dart:convert';
import 'dart:io';

import 'package:industrial_asset_management_mobile/const/Strings.dart';
import 'package:http/http.dart' as http;


class UploadFile {
   bool? success;
   String? message;

   bool? isUploaded;

  Future<void> call(String url, File image) async {
    try {
      var response = await http.put( Uri.parse(url), body: image.readAsBytesSync());
      if (response.statusCode == 200) {
        isUploaded = true;
      }
    } catch (e) {
      isUploaded = false;
      throw ('Error uploading photo');
    }
  }
}


class GenerateImageUrl {
   bool? success;
   String? message;

   bool? isGenerated;
   String? uploadUrl;
   String? downloadUrl;



  Future<void> call(String fileType) async {
    try {
      Map body = {"fileType": ".png"};

      var response = await http.post(
        Uri.parse(Strings.urlServerGetUrlToUpload)
       ,

        body: body,
      );

      var result = jsonDecode(response.body);

      print(result);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if (response.statusCode == 201) {
          isGenerated = true;
          uploadUrl = result["uploadUrl"];
          downloadUrl = result["downloadUrl"];
        }
      }
    } catch (e) {


    }
  }
}