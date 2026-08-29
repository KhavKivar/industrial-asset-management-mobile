import 'package:industrial_asset_management_mobile/model/equipo.dart';
import 'package:industrial_asset_management_mobile/ui/detalle_equipo_pages/top_side_ui.dart';
import 'package:industrial_asset_management_mobile/ui/responsive_layout.dart';
import 'package:flutter/cupertino.dart';

class DetalleDispatcher extends StatelessWidget {
  const DetalleDispatcher({Key? key, required this.equipo}) : super(key: key);
  final Equipo equipo;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: CardEquipoDetalle(equipo: equipo, tipo: "mobile"),
        tabletBody: CardEquipoDetalle(equipo: equipo, tipo: "tablet"),
        desktopBody: CardEquipoDetalle(equipo: equipo, tipo: "desktop"));
  }
}
