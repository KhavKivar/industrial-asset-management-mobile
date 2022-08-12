import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/model/state/app_state.dart';
import 'package:app_licman/ui/view_acta_page/dispatcher_acta_only_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardMovimientoWidget extends StatelessWidget {
  CardMovimientoWidget({Key? key, required this.movimiento}) : super(key: key);
  final Movimiento movimiento;
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () {
          final int indexActa = Provider.of<AppState>(context, listen: false)
              .inspeccionList
              .lastIndexWhere(
                  (element) => element.idInspeccion == movimiento.idInspeccion);

          if (indexActa != -1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DispatcherActaOnlyView(
                        inspeccion:
                            Provider.of<AppState>(context, listen: false)
                                .inspeccionList[indexActa]))).then((value) {
              FocusScope.of(context).requestFocus(FocusNode());
            });
          }
          ;
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              _RowText(
                  firstValue: "Fecha",
                  secondValue: formatter.format(movimiento.fechaMov)),
              _RowText(
                  firstValue: "Transporte ",
                  secondValue: movimiento.transporte),
              _RowText(
                  firstValue: "Empresa ",
                  secondValue: movimiento.nombreCliente),
              _RowText(firstValue: "Tipo ", secondValue: movimiento.tipo),
              _RowText(
                  firstValue: "Codigo interno",
                  secondValue: movimiento.equipoId.toString()),
              _RowText(
                  firstValue: "Acta ID ",
                  secondValue: movimiento.idInspeccion.toString()),
              _RowText(
                  firstValue: "Cambio ",
                  secondValue: movimiento.cambio == null
                      ? "-"
                      : movimiento.cambio.toString()),
              _RowText(
                  firstValue: "N° guia de despacho",
                  secondValue: movimiento.idGuiaDespacho == null
                      ? "-"
                      : movimiento.idGuiaDespacho.toString()),
              _RowText(
                  firstValue: "Observacion ",
                  secondValue: movimiento.observaciones.toString()),
              _RowText(
                firstValue: "Fecha retiro ",
                secondValue: (movimiento.fechaRetiro == null
                    ? "-"
                    : formatter.format(movimiento.fechaRetiro!)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  const _RowText(
      {Key? key, required this.firstValue, required this.secondValue})
      : super(key: key);
  final String firstValue;
  final String secondValue;
  final fontSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          firstValue,
          style: TextStyle(fontSize: fontSize),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: AutoSizeText(
              secondValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        )
      ],
    );
  }
}
