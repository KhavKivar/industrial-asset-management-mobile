import 'package:industrial_asset_management_mobile/model/equipo.dart';
import 'package:industrial_asset_management_mobile/ui/detalle_equipo_pages/top_side_ui.dart';
import 'package:industrial_asset_management_mobile/ui/responsive_layout.dart';
import 'package:industrial_asset_management_mobile/ui/tables_pages/top_navigator_table.dart';
import 'package:flutter/cupertino.dart';

class TableDispatcher extends StatelessWidget {
  const TableDispatcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobileBody: TableOfActas(device: "mobile"),
        tabletBody: TableOfActas(device: "tablet"),
        desktopBody: TableOfActas(device: "desktop"));
  }
}
