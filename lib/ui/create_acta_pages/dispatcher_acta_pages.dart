import 'dart:typed_data';

import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/ui/create_acta_pages/acta_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../../model/inspeccion.dart';
import '../responsive_layout.dart';

class DispatcherActaCreatePages extends StatelessWidget {
  const DispatcherActaCreatePages(
      {Key? key, this.edit, this.id, this.onlyCacheSave, this.data})
      : super(key: key);
  final bool? edit;
  final int? id;
  final bool? onlyCacheSave;
  final Uint8List? data;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: ActaPageView(
          device: 'mobile',
          edit: edit,
          id: id,
          onlyCacheSave: onlyCacheSave,
          data: data,
        ),
        tabletBody: ActaPageView(
          device: 'tablet',
          edit: edit,
          id: id,
          onlyCacheSave: onlyCacheSave,
          data: data,
        ),
        desktopBody: ActaPageView(
          device: 'desktop',
          edit: edit,
          id: id,
          onlyCacheSave: onlyCacheSave,
          data: data,
        ));
  }
}
