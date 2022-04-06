import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/modeloimagen.dart';
import 'package:app_licman/model/state/app_state.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class CardEquipo extends StatelessWidget {
  CardEquipo({Key? key, required this.equipo}) : super(key: key);
  final Equipo equipo;

  Map<String, String> modeloToAssetPath = {
    "ETV 214": "assets/ETV 214.jpg",
    "ERE 224": "assets/" + "ERE 224.jpg",
    "H2.0TX-ET": "assets/" + "Hyster H2.5FT.png",
    "H3.0FT": "assets/" + "H3.0FT.jpg",
    "EFG 220": "assets/" + "EFG 220.jpg",
  };
  final fontSizeText = 15.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<ModeloImg> modeloList =
        Provider.of<AppState>(context, listen: false).imgList;

    return LayoutBuilder(builder: (context, snapshot) {
      double maxHeight = snapshot.maxHeight;
      double photoHeight = maxHeight * (6 / 10);
      double infoHeight = maxHeight * (4 / 10);

      return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 8,
          margin: EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: photoHeight,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: modeloList
                            .any((element) => element.modelo == equipo.modelo)
                        ? modeloList
                            .firstWhere(
                                (element) => element.modelo == equipo.modelo)
                            .url
                        : "https://www.med.ufro.cl/saludpublica/images/construccion/EnConstruccion_seccion.gif",
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 15.0,
                                width: 15.0,
                                decoration: BoxDecoration(
                                    color: equipo.estado == 'DISPONIBLE'
                                        ? Colors.yellow
                                        : equipo.estado == 'LISTO PARA ENVIAR'
                                            ? Colors.green
                                            : equipo.estado == 'ARRENDADO'
                                                ? Colors.red
                                                : equipo.estado == 'VENDIDO'
                                                    ? Colors.red
                                                    : equipo.estado == 'REMATE'
                                                        ? Colors.red
                                                        : equipo.estado ==
                                                                'POR LLEGAR'
                                                            ? Colors
                                                                .yellowAccent
                                                            : equipo.estado ==
                                                                    'STAND BY'
                                                                ? Colors
                                                                    .lightGreenAccent
                                                                : equipo.estado ==
                                                                        'SIN INFORMACION'
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                equipo.estado.toCapitalized(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fontSizeText),
                              )
                            ],
                          ),
                          RowText(
                              firstText: "Codigo interno",
                              secondText: equipo.id.toString()),
                          RowText(
                              firstText: "Ubicacion",
                              secondText: equipo.ubicacion.toString()),
                          RowText(
                              firstText: "Tipo",
                              secondText: equipo.tipo.toString()),
                          RowText(
                              firstText: "Modelo",
                              secondText: equipo.modelo.toString()),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

class RowText extends StatelessWidget {
  const RowText({Key? key, required this.firstText, required this.secondText})
      : super(key: key);
  final String firstText;
  final String secondText;
  final fontSizeText = 15.0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            firstText,
            style: TextStyle(color: Colors.black, fontSize: fontSizeText),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                secondText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: fontSizeText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
