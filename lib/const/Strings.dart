class Strings {
  //Server
  static const String urlServerReal = "https://licman-backend.xyz";
  //Dev Serverx
  static const String localServer = "http://10.0.2.2:3000";
  //Desktop Sv
  static const String desktopLocalSv = "http://localhost:3000";

  static const String urlServer = desktopLocalSv;

  static const String urlServerGetEquipos = urlServer + "/api/equipo";

  static const String urlServerGetInspecciones = urlServer + "/api/inspeccion";
  static const String urlServerGetImg = urlServer + "/api/modelo";

  static const String urlServerPostInps = urlServer + "/api/inspeccion/";
  static const String urlServerGetUrlToUpload =
      urlServer + "/generatePresignedurl";
  static const String urlServerGetUpdateState =
      urlServer + "/api/getLastUpdate/";
  static const String urlServerEditInps = urlServer + "/api/inspeccion/id/";
  static const String urlServerGetMovimientos = urlServer + "/api/movimiento/";

  static const String urlServerGetClientes = urlServer + "/api/cliente/";

  static const String urlServerLogin = urlServer + "/api/usuario/login/";
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return "";
    }
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
