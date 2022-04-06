import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../const/Colors.dart';
import '../model/state/common_var_state.dart';
import '../repository/update_resources_repository.dart';
import '../ui/cola_actas_page.dart';
import '../ui/create_acta_pages/acta_page_view.dart';
import '../ui/create_acta_pages/dispatcher_acta_pages.dart';

class MyDrawer extends StatelessWidget {
  final double fontSizeDrawHeader = 25;
  final double fontSizeItem = 20;
  const MyDrawer({Key? key, this.device}) : super(key: key);
  final device;
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
        message: 'Actualizando...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: yellowBackground,
            ),
            child: Row(
              children: [
                Text(
                  'Opciones',
                  style: TextStyle(fontSize: fontSizeDrawHeader),
                ),
              ],
            ),
          ),
          if (device.toString() == 'mobile')
            ListTile(
              title: Text(
                'Crear acta',
                style: TextStyle(fontSize: fontSizeItem),
              ),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DispatcherActaCreatePages()),
                ).then((value) {
                  print("back");
                });
              },
            ),
          ListTile(
            title: Text(
              'Actas sin enviar',
              style: TextStyle(fontSize: fontSizeItem),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ColaActaPage()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                const Icon(Icons.refresh),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Actualizar  ',
                  style: TextStyle(fontSize: fontSizeItem),
                ),
              ],
            ),
            onTap: () async {
              await pr.show();
              UpdateStateRepository().update(context).then((x) {
                Future.delayed(Duration(milliseconds: 700));
                pr.hide();
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
