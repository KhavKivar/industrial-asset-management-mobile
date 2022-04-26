import '../model/cola.dart';
import '../services/hive_services.dart';

class ColaRepository {
  final HiveService hiveService = HiveService();
  get() async {
    List<Cola> lista = await hiveService.getBoxes<Cola>('cola');

    return lista;
  }
}
