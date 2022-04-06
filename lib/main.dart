import 'package:app_licman/model/cliente.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/model/state/app_state.dart';
import 'package:app_licman/services/login_services.dart';
import 'package:app_licman/ui/home_page.dart';
import 'package:app_licman/ui/login.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import 'const/Colors.dart';
import 'intent_file.dart';
import 'model/cola.dart';
import 'model/inspeccion.dart';
import 'model/modeloimagen.dart';
import 'model/state/acta_state.dart';
import 'model/state/common_var_state.dart';
import 'model/updateTime.dart';

void main() async {
  Future.delayed(const Duration(milliseconds: 1)).then((value) =>
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, // navigation bar color
        statusBarColor: Colors.black, // status
      )));

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    final appDirectory = await path_provider.getApplicationDocumentsDirectory();

    Hive.init(appDirectory.path + "/data/hive/");
  }
  Hive.registerAdapter(EquipoAdapter());
  Hive.registerAdapter(ModeloImgAdapter());
  Hive.registerAdapter(InspeccionAdapter());
  Hive.registerAdapter(UpdateTimeAdapter());
  Hive.registerAdapter(ColaAdapter());
  Hive.registerAdapter(MovimientoAdapter());
  Hive.registerAdapter(ClienteAdapter());
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<bool> _validateToken() async {
    var box = await Hive.openBox('user');
    final token = box.get('token');
    final user = box.get('user');

    if (token != null && user != null && user != null) {
      final resultado = await loginViaToken(user, token);
      return resultado;
    }
    return false;
  }

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppState()),
          ChangeNotifierProvider(create: (context) => CommonState()),
          ChangeNotifierProvider(create: (context) => ActaState())
        ],
        child: MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            scrollBehavior: MyCustomScrollBehavior(),
            title: 'Licman App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'Poppins',
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: yellowBackground),
            home: FutureBuilder<bool>(
                future: _validateToken(),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      return const Homepage();
                    } else {
                      return const LoginPage();
                    }
                  }
                  return const Scaffold(
                      body: Center(
                    child: CircularProgressIndicator(),
                  ));
                })));
  }
}
