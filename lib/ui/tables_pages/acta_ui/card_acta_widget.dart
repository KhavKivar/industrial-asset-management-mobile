import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/state/acta_state.dart';
import 'package:app_licman/model/state/common_var_state.dart';
import 'package:app_licman/plugins/dart_rut_form.dart';
import 'package:app_licman/ui/create_acta_pages/dispatcher_acta_pages.dart';
import 'package:app_licman/ui/view_acta_page/dispatcher_acta_only_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardActaWidget extends StatelessWidget {
  CardActaWidget({Key? key, required this.inspeccion, required this.device})
      : super(key: key);
  final Inspeccion inspeccion;

  final String device;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(width: 1.0, color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _RowText(
                      device: device,
                      firstValue: "Acta ID",
                      secondValue: inspeccion.idInspeccion.toString()),
                  _RowText(
                    firstValue: "Codigo interno",
                    secondValue: inspeccion.idEquipo.toString(),
                    device: device,
                  ),
                  _RowText(
                    firstValue: "Rut receptor",
                    secondValue:
                        RUTValidator.formatFromText(inspeccion.rut.toString()),
                    device: device,
                  ),
                  _RowText(
                    firstValue: "Nombre receptor ",
                    secondValue: inspeccion.nombre.toString(),
                    device: device,
                  ),
                  _RowText(
                    firstValue: "Observaciones",
                    secondValue: inspeccion.observacion.toString(),
                    device: device,
                  ),
                  _RowText(
                    firstValue: "Ultima actualizacion",
                    secondValue: inspeccion.ts == null
                        ? "-"
                        : formatter.format(inspeccion.ts!),
                    device: device,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DispatcherActaOnlyView(
                                  inspeccion: inspeccion))).then((value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(4))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Provider.of<ActaState>(context, listen: false)
                          .convertObjectTostate(inspeccion, context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DispatcherActaCreatePages(
                                  edit: true,
                                  id: inspeccion.idInspeccion))).then((value) {
                        Provider.of<CommonState>(context, listen: false)
                            .changeActaIndex(0);
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(4))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  const _RowText(
      {Key? key,
      required this.firstValue,
      required this.secondValue,
      required this.device})
      : super(key: key);
  final String firstValue;
  final String secondValue;
  final String device;
  final fontSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: device == 'mobile'
              ? MediaQuery.of(context).size.width * 0.4
              : device == 'tablet'
                  ? MediaQuery.of(context).size.width * (0.4 / 2.0)
                  : MediaQuery.of(context).size.width * (0.4 / 3.0),
          child: AutoSizeText(
            firstValue,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: AutoSizeText(
              secondValue,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize),
              maxLines: 1,
            ),
          ),
        )
      ],
    );
  }
}
