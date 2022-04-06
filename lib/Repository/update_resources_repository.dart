import 'package:app_licman/model/cliente.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/movimiento.dart';

import 'package:app_licman/model/updateTime.dart';
import 'package:app_licman/repository/movimientos_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../model/state/app_state.dart';

import '../services/hive_services.dart';
import '../services/util.dart';
import 'Img_repository.dart';
import 'Inspeccion_repository.dart';
import 'cliente_repository.dart';
import 'equipo_repository.dart';

class UpdateStateRepository {
  final HiveService hiveService = HiveService();

  Future<bool> update(context) async {
    UpdateTime cacheEq = await (hiveService.getBox('cache_time_equipo'));
    UpdateTime cacheImg = await (hiveService.getBox('cache_time_img'));
    UpdateTime cacheActa = await (hiveService.getBox('cache_time_acta'));
    UpdateTime cacheMovimientos =
        await (hiveService.getBox('cache_time_movimiento'));
    UpdateTime cacheClientes = await (hiveService.getBox('cache_time_cliente'));
    List<UpdateTime> realUpdateList = await getLastUpdate();
    dynamic contextMain =
        Provider.of<AppState>(context, listen: false).contextMain;

    if (realUpdateList.length == 5) {
      if (cacheEq.updateTime.toString() !=
          realUpdateList[0].updateTime.toString()) {
        if (kDebugMode) {
          print("UPDATE CACHE EQUIPO");
        }
        Provider.of<AppState>(contextMain, listen: false)
            .setEquipo(await EquipoRepository().get(true));
      }
      //Actualizar cache de actas
      if (cacheActa.updateTime.toString() !=
          realUpdateList[1].updateTime.toString()) {
        if (kDebugMode) {
          print("UPDATE CACHE INSPECCION");
        }

        final listaActualizada = await InspeccionRepository().get(true);
        Provider.of<AppState>(contextMain, listen: false)
            .setInspeccion(listaActualizada);
        Provider.of<AppState>(contextMain, listen: false)
            .setFilterList(listaActualizada);
        print("finish");
      }
      //Actualizar el cache de modeloImagen

      if (cacheImg.updateTime.toString() !=
          realUpdateList[2].updateTime.toString()) {
        if (kDebugMode) {
          print("UPDATE CACHE MODELO IMAGEN");
        }
        Provider.of<AppState>(contextMain, listen: false)
            .setImgList(await ImgRepository().get(true));
      }

      if (cacheMovimientos.updateTime.toString() !=
          realUpdateList[3].updateTime.toString()) {
        if (kDebugMode) {
          print("UPDATE CACHE MOVIMIENTOS");
        }
        List<Movimiento> movimientos = await MovimientoRepository().get(true);
        List<Inspeccion> actas =
            Provider.of<AppState>(contextMain, listen: false).inspeccionList;
        List<Cliente> clientes =
            Provider.of<AppState>(context, listen: false).clientes;

        for (int i = 0; i < movimientos.length; i++) {
          int indexActa = actas
              .indexWhere((x) => x.idInspeccion == movimientos[i].idInspeccion);
          if (indexActa != -1) {
            movimientos[i].equipoId = actas[indexActa].idEquipo.toString();
          }
          int indexCliente = clientes.indexWhere(
              (x) => x.rut.toString() == movimientos[i].rut.toString());
          if (indexCliente != -1) {
            movimientos[i].nombreCliente = clientes[indexCliente].nombre;
          }
        }
        Provider.of<AppState>(contextMain, listen: false)
            .setMovimientoList(movimientos);
        Provider.of<AppState>(contextMain, listen: false)
            .setFilterMovList(movimientos);
      }

      if (cacheClientes.updateTime.toString() !=
          realUpdateList[4].updateTime.toString()) {
        if (kDebugMode) {
          print("UPDATE CACHE CLIENTE");
        }
        final listaActualizada = await ClienteRepository().get(true);

        Provider.of<AppState>(contextMain, listen: false)
            .setClientes(listaActualizada);
      }
    }
    return true;
  }
}
