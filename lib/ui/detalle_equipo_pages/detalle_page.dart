import 'package:app_licman/const/Strings.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../const/Colors.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key? key, required this.equipo}) : super(key: key);
  final Equipo equipo;
  final double fontSizeContent = 23;
  final numberFormatter = NumberFormat.decimalPattern('de-DE');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          RowWidget(
            value: equipo.id.toString(),
            title: 'Codigo interno',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.estado.capitalize(),
            title: 'Estado',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.ubicacion,
            title: 'Ubicacion',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.tipo,
            title: 'Tipo',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.modelo,
            title: 'Modelo',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.marca,
            title: 'Marca',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.serie,
            title: 'Serie',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.altura.toString().replaceAll(".", ",") + " mm",
            title: 'Altura',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: numberFormatter.format(equipo.capacidad).toString() + " Kg",
            title: 'Capacidad',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.mastil.capitalize(),
            title: 'Mastil',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: numberFormatter.format(equipo.horometro).toString(),
            title: 'Horometro',
            fontSizeContent: fontSizeContent,
            borderBool: false,
          ),
          RowWidget(
            value: equipo.ano.toString(),
            title: 'Año',
            fontSizeContent: fontSizeContent,
            borderBool: true,
          ),
        ],
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  const RowWidget(
      {Key? key,
      required this.title,
      required this.value,
      required this.fontSizeContent,
      required this.borderBool})
      : super(key: key);
  final String title;
  final String value;
  final double fontSizeContent;
  final bool borderBool;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 1.5, color: dark)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: AutoSizeText(
                      title,
                      style: TextStyle(fontSize: fontSizeContent),
                    ),
                  ),
                ),
                SizedBox(
                  height: double.infinity,
                  child: AutoSizeText(
                    value,
                    style: TextStyle(
                        color: Colors.grey, fontSize: fontSizeContent),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
