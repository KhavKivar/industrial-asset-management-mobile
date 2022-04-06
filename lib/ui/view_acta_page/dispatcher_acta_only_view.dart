import 'package:app_licman/model/inspeccion.dart';
import 'package:flutter/cupertino.dart';

import '../../model/inspeccion.dart';
import '../responsive_layout.dart';
import 'acta_only_view_page.dart';

class DispatcherActaOnlyView extends StatelessWidget {
  const DispatcherActaOnlyView({Key? key, required this.inspeccion})
      : super(key: key);
  final Inspeccion inspeccion;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: ActaOnlyView(inspeccion: inspeccion, tipo: "mobile"),
        tabletBody: ActaOnlyView(inspeccion: inspeccion, tipo: "tablet"),
        desktopBody: ActaOnlyView(inspeccion: inspeccion, tipo: "desktop"));
  }
}
