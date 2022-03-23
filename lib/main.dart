import 'dart:ui';

import 'package:app_licman/model/cliente.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/model/state/equipoState.dart';
import 'package:app_licman/ui/ui_creacion_acta/acta_general_page.dart';
import 'package:app_licman/ui/ui_acta/acta_inspeccion_page.dart';
import 'package:app_licman/ui/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'const/Colors.dart';
import 'model/cola.dart';
import 'model/inspeccion.dart';
import 'model/modeloimagen.dart';
import 'model/state/actaState.dart';

import 'model/state/commonVarState.dart';


import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/updateTime.dart';


void main() async {
  Future.delayed(Duration(milliseconds: 1)).then(
          (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.black, // navigation bar color
            statusBarColor: Colors.black, // status
      )));

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {

    final appDirectory = await path_provider.getApplicationDocumentsDirectory();



     Hive.init(appDirectory.path+"/data/hive/");

  }
  Hive.registerAdapter(EquipoAdapter());
  Hive.registerAdapter(ModeloImgAdapter());
  Hive.registerAdapter(InspeccionAdapter());
  Hive.registerAdapter(UpdateTimeAdapter());
  Hive.registerAdapter(ColaAdapter());
  Hive.registerAdapter(MovimientoAdapter());
  Hive.registerAdapter(ClienteAdapter());

  runApp( MyApp());

}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

/// A ShortcutManager that logs all keys that it hapndles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);

    if (result == KeyEventResult.handled) {

    }
    return result;
  }
}



/// TextEditingController.
class nextPageIntent extends Intent {
  const nextPageIntent();
}


class nextPageAction extends Action<nextPageIntent> {
  nextPageAction(this.controller,[this.callback]);
  final PageController controller;
  dynamic callback;

  @override
  Object? invoke(covariant nextPageIntent intent) {
    if(callback  != null){
        callback(1);
    }

    controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut);
    return null;
  }
}
/// TextEditingController.
class previousPageIntent extends Intent {
  const previousPageIntent();
}


class previousPageAction extends Action<previousPageIntent> {
  previousPageAction(this.controller,[this.callback]);
  final PageController controller;
  dynamic callback;



  @override
  Object? invoke(covariant previousPageIntent intent) {
    if(callback  != null){
      callback(0);
    }
      controller.previousPage(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut);

    return null;
  }
}



/// TextEditingController.
class downIntent extends Intent {
  const downIntent();
}


class downAction extends Action<downIntent> {
  downAction(this.controller);
  var controller;



  @override
  Object? invoke(covariant downIntent intent) {
    if(controller is DataGridController){

      controller.scrollToVerticalOffset(controller.verticalOffset+100.0,canAnimate:true);
    }else{


    controller.animateTo(
        controller.offset+150,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease
    ) ;
    }
    return null;
  }
}



/// TextEditingController.
class upIntent extends Intent {
  const upIntent();
}


class upAction extends Action<upIntent> {
  upAction(this.controller);
  var  controller;



  @override
  Object? invoke(covariant upIntent intent) {
    if(controller is DataGridController){

       controller.scrollToVerticalOffset(controller.verticalOffset-200.0,canAnimate:true);
    }else{
    controller.animateTo(
        controller.offset-150,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease
    ) ;}
    return null;
  }
}














class closePageIntent extends Intent {
  const closePageIntent();
}


class closePageAction extends Action<closePageIntent> {
  closePageAction(this.context,[this.callBack]);
  var context;
  dynamic callBack;


  @override
  Object? invoke(covariant closePageIntent intent) {

    if(callBack != null){
      callBack();
    }
    Navigator.pop(context);

    return null;
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EquipoState()),

        ChangeNotifierProvider(create: (context) => CommonState()),
        ChangeNotifierProvider(create: (context) => ActaState())
      ],
      child: MaterialApp(
         scrollBehavior: MyCustomScrollBehavior(),
        title: 'Licman App',
          debugShowCheckedModeBanner: false,
        theme:ThemeData(fontFamily: 'Poppins',
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor:yellowBackground
        ),
        home: Homepage()
      ),
    );
  }
}
