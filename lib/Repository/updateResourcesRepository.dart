import 'package:app_licman/Repository/EquipoRepository.dart';
import 'package:app_licman/Repository/ImgRepository.dart';
import 'package:app_licman/Repository/InspeccionRepository.dart';
import 'package:app_licman/Repository/clienteRepositor.dart';
import 'package:app_licman/Repository/movimientoRepository.dart';
import 'package:app_licman/model/cliente.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/model/state/equipoState.dart';
import 'package:app_licman/model/updateTime.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../services/hive_services.dart';
import '../services/util.dart';

class UpdateStateRepository {
  final HiveService hiveService = HiveService();

  update(context) async {
    UpdateTime cache_eq = await (hiveService.getBox('cache_time_equipo'));
    UpdateTime cache_img = await (hiveService.getBox('cache_time_img'));
    UpdateTime cache_acta = await (hiveService.getBox('cache_time_acta'));
    UpdateTime cache_movimientos =
        await (hiveService.getBox('cache_time_movimiento'));
    UpdateTime cache_clientes =
    await (hiveService.getBox('cache_time_cliente'));
    List<UpdateTime> realUpdateList = await getLastUpdate();
    dynamic contextMain =
        Provider.of<EquipoState>(context, listen: false).contextMain;

    if (realUpdateList.length == 5) {
      if (cache_eq.updateTime.toString() !=
          realUpdateList[0].updateTime.toString()) {
        print("UPDATE CACHE EQUIPO");
        Provider.of<EquipoState>(contextMain, listen: false)
            .setEquipo(await EquipoRepository().get(true));
      }
      //Actualizar cache de actas
      if (cache_acta.updateTime.toString() !=
          realUpdateList[1].updateTime.toString()) {
        print("UPDATE CACHE INSPECCION");
        print(context.toString());
        final lista_actualizada = await InspeccionRepository().get(true);
        Provider.of<EquipoState>(contextMain, listen: false)
            .setInspeccion(lista_actualizada);
        Provider.of<EquipoState>(contextMain,listen: false).setFilterList(lista_actualizada);

      }
      //Actualizar el cache de modeloImagen

      if (cache_img.updateTime.toString() !=
          realUpdateList[2].updateTime.toString()) {
        print("UPDATE CACHE MODELO IMAGEN");
        Provider.of<EquipoState>(contextMain, listen: false)
            .setImgList(await ImgRepository().get(true));
      }

      if (cache_movimientos.updateTime.toString() !=
          realUpdateList[3].updateTime.toString()) {
        print("UPDATE CACHE MOVIMIENTOS");
        List<Movimiento> movimientos = await MovimientoRepository().get(true);
        List<Inspeccion> actas = Provider.of<EquipoState>(contextMain,listen: false).inspeccionList;
        List<Cliente> clientes = Provider.of<EquipoState>(context,listen: false).clientes;

        for(int i=0;i<movimientos.length;i++){
          int index_acta = actas.indexWhere( (x) => x.idInspeccion == movimientos[i].idInspeccion);
          if(index_acta != -1){
            movimientos[i].equipoId = actas[index_acta].idEquipo.toString();
          }
          int index_cliente =  clientes.indexWhere( (x) => x.rut.toString() == movimientos[i].rut.toString());
          if(index_cliente != -1){
            movimientos[i].nombreCliente = clientes[index_cliente].nombre;
          }
        }
        Provider.of<EquipoState>(contextMain, listen: false)
            .setMovimientoList(movimientos);
        Provider.of<EquipoState>(contextMain,listen: false).setFilterMovList(movimientos);


      }

      if (cache_clientes.updateTime.toString() !=
          realUpdateList[4].updateTime.toString()) {
        print("UPDATE CACHE CLIENTE");
        final lista_actualizada = await ClienteRepository().get(true);

        Provider.of<EquipoState>(contextMain, listen: false)
            .setClientes(lista_actualizada);

      }
    }
  }
}
