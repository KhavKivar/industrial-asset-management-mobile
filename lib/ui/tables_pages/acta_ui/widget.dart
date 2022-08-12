import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/state/app_state.dart';
import 'package:app_licman/model/state/common_var_state.dart';
import 'package:app_licman/plugins/dart_rut_form.dart';
import 'package:app_licman/ui/tables_pages/acta_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchWidgetActa extends StatefulWidget {
  SearchWidgetActa({Key? key}) : super(key: key);

  @override
  State<SearchWidgetActa> createState() => _SearchWidgetActaState();
}

class _SearchWidgetActaState extends State<SearchWidgetActa> {
  DateRangePickerController dateController = DateRangePickerController();
  TextEditingController? searchController;
  bool showFilter = false;
  @override
  void initState() {
    // TODO: implement initState
    /*final now = DateTime.now();
    dateController.selectedDate = DateTime(now.year, now.month);

    searchController = TextEditingController(
        text: Provider.of<AppState>(context, listen: false).searchActasText);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: dark, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: TextStyle(color: dark, fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Buscar actas..',
                hintStyle: const TextStyle(fontSize: 20),
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                suffixIcon: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    onPressed: () {
                      setState(() {
                        showFilter = !showFilter;
                      });
                    },
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      color: dark,
                      size: 25,
                    )),
              ),
              onChanged: (value) {
                logicaFiltros(value);
              },
            ),
            if (showFilter)
              Column(
                children: [
                  Divider(
                    color: Colors.black,
                    height: 5.0,
                    thickness: 1.0,
                  ),
                  FilterPanelWidget(
                    dateController: dateController,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void logicaFiltros(value) {
    Provider.of<AppState>(context, listen: false).setSearchActa(value);

    var actas = Provider.of<AppState>(context, listen: false).inspeccionList;
    var filtros = Provider.of<CommonState>(context, listen: false).listaFiltro;
    var fecha = null;
    if (dateController.selectedDate != null) {
      fecha = dateController.selectedDate.toString().split("-")[0] +
          "-" +
          dateController.selectedDate.toString().split("-")[1];
    }

    switch (filtros) {
      case 0:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  element.idInspeccion
                      .toString()
                      .startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();

          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;
      case 1:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  element.idEquipo.toString().startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();
          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;
      case 2:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  (element.rut!.startsWith(value.toLowerCase()) ||
                      RUTValidator.deFormat(element.rut!)
                          .startsWith(value.toLowerCase())) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();
          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;

      case 3:
        {
          List<Inspeccion> resultado = actas
              .where((element) =>
                  element.ts.toString().startsWith(value.toLowerCase()) &&
                  (fecha == null
                      ? true
                      : element.ts.toString().startsWith(fecha)))
              .toList();
          Provider.of<AppState>(context, listen: false)
              .setFilterList(resultado);
        }
        break;
    }
  }
}
