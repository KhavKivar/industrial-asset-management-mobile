import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_licman/model/state/equipoState.dart';
import 'package:app_licman/ui/ui_acta/acta_only_view_page.dart';
import 'package:app_licman/ui/ui_creacion_acta/acta_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../const/Colors.dart';
import '../model/cola.dart';
import '../model/inspeccion.dart';
import '../model/state/actaState.dart';
import '../model/state/commonVarState.dart';
import '../services/generate_image_url.dart';
import 'package:http/http.dart' as http;

import '../services/hive_services.dart';
import '../services/inspeccion_services.dart';

class ColaActaPage extends StatefulWidget {
  ColaActaPage({Key? key}) : super(key: key);

  @override
  State<ColaActaPage> createState() => _ColaActaPageState();
}

class _ColaActaPageState extends State<ColaActaPage> {
  var fontSizeRowHead = 20.0;

  var fontSizeRow = 20.0;

  var buttonTextSize = 25.0;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<Cola> listaCola = Provider.of<EquipoState>(context).listCola;

    return Scaffold(
        appBar: AppBar(
          title: Text("Cola de actas"),
          backgroundColor: dark,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () async {
                                //Enviar la imagen
                                setState(() {
                                  isLoading = true;
                                });
                                List<Cola> colas = Provider.of<EquipoState>(
                                        context,
                                        listen: false)
                                    .listCola;
                                List<Cola> toRemove = [];
                                if (colas.length > 0) {
                                  print("cola ${colas.length}");
                                  for (int i = 0; i < colas.length; i++) {
                                    Cola cola = colas[i];
                                    try {
                                      bool resultx =
                                          await enviarActa(cola, context, i);
                                      print("i ${i} result ${resultx}");
                                      if (resultx) {
                                        print("result ok ${i}");
                                        toRemove.add(cola);
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                }
                                if(toRemove.length>0){
                                  for(int i=0;i<toRemove.length;i++){
                                    Cola colaDelete = toRemove[i];
                                    Provider.of<EquipoState>(context, listen: false).removeCola(colaDelete);
                                    colaDelete.delete();
                                  }
                                }
                                await Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              icon: Icon(
                                Icons.refresh,
                                size: 30,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Actualizar",
                                  style: TextStyle(fontSize: buttonTextSize),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: DataTable(
                        dataRowHeight: 70,
                        showBottomBorder: true,
                        sortColumnIndex: 0,
                        sortAscending: false,
                        headingRowColor:
                            MaterialStateColor.resolveWith((states) => dark),
                        rows: [
                          for (int i = 0; i < listaCola.length; i++)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  listaCola[i].acta!.idEquipo.toString(),
                                  style: TextStyle(fontSize: fontSizeRow),
                                )),
                                DataCell(Text(listaCola[i].ts,
                                    style: TextStyle(fontSize: fontSizeRow))),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.visibility),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActaOnlyView(
                                                        inspeccion:
                                                            listaCola[i].acta!,
                                                        data: listaCola[i]
                                                                    .data ==
                                                                null
                                                            ? null
                                                            : listaCola[i].data,
                                                      )));
                                        },
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Inspeccion acta =
                                                listaCola[i].acta!;
                                            Provider.of<ActaState>(context,
                                                    listen: false)
                                                .convertObjectTostate(
                                                    acta, context);
                                            Provider.of<EquipoState>(context,
                                                    listen: false)
                                                .setIndexCola(i);

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActaPageView(
                                                          edit: true,
                                                          onlyCacheSave: true,
                                                          data:
                                                              listaCola[i].data,
                                                        )));
                                          },
                                          icon: Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                        columns: [
                          DataColumn(
                            label: Text(
                              'Acta ID',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSizeRowHead),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Fecha',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSizeRowHead),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Acciones',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSizeRowHead),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                  color: dark.withOpacity(0.5),
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator())),
          ],
        ));
  }

  Future<String> enviarImagen(Uint8List? dataImg) async {
    try {
      final Uint8List? data = dataImg;

      //enviar la foto
      GenerateImageUrl generateImageUrl = GenerateImageUrl();
      await generateImageUrl.call(".png");

      String uploadUrl;
      if (generateImageUrl.isGenerated != null &&
          generateImageUrl.isGenerated!) {
        uploadUrl = generateImageUrl.uploadUrl!;
      } else {
        throw generateImageUrl.message!;
      }

      Uint8List imageInUnit8List = data!;
      final tempDir = await getTemporaryDirectory();

      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(imageInUnit8List);
      var response =
          await http.put(Uri.parse(uploadUrl), body: file.readAsBytesSync());
      return generateImageUrl.downloadUrl!;
    } catch (e) {
      return "";
    }
  }

  Future<bool> enviarActa(Cola cola, context, int index) async {
    Inspeccion acta = cola.acta!;

    String urlImg = await enviarImagen(cola.data);
    acta.firmaUrl = urlImg;

    try {
      final result = await sendActa(acta);
      if (result != null) {
        print("entro cola ${cola.acta?.idInspeccion.toString()}");
        Provider.of<EquipoState>(context, listen: false).addActa(result);
        Provider.of<EquipoState>(context, listen: false)
            .setHorometro(acta.idEquipo!, acta.horometroActual!);
        Provider.of<CommonState>(context, listen: false).changeActaIndex(0);
        //Eliminar la cola del provider y despues del cache

        return true;
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Row(
            children: [
              Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "NO SE PUDO ENVIAR LA ACTA ID EQUIPO: " +
                      acta.idEquipo.toString() +
                      " Error: No hay internet",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          )));
    } on HttpException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Row(
            children: [
              Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "NO SE PUDO ENVIAR LA ACTA ID EQUIPO: " +
                      acta.idEquipo.toString() +
                      " Error:" +
                      e.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Row(
            children: [
              Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "NO SE PUDO ENVIAR LA ACTA ID EQUIPO: " +
                    acta.idEquipo.toString(),
                style: TextStyle(fontSize: 18),
              ),
            ],
          )));
    }
    return false;
  }
}
