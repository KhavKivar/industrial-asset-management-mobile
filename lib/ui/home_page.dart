import 'dart:async';

import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/inspeccion.dart';
import 'package:app_licman/model/modeloimagen.dart';
import 'package:app_licman/model/movimiento.dart';
import 'package:app_licman/model/state/acta_state.dart';
import 'package:app_licman/model/state/app_state.dart';

import 'package:app_licman/widget/bottomNavigator.dart';
import 'package:app_licman/widget/card_equipo_widget.dart';
import 'package:app_licman/widget/drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../const/Strings.dart';
import '../intent_file.dart';
import '../model/cliente.dart';
import '../model/editCliente.dart';
import '../plugins/flutter_typeahed/src/flutter_typeahead.dart';
import '../repository/update_resources_repository.dart';
import 'detalle_equipo_pages/dispatcher_device.dart';
import 'detalle_equipo_pages/top_side_ui.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Homepage extends StatefulWidget {
  const Homepage({Key? key, required this.showInternetError}) : super(key: key);
  final bool showInternetError;

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  int choose = -1;
  double witt = 300;
  final searchController = TextEditingController();
  bool select = false;
  List<Equipo> equipos = [];

  bool isNotSearching = false;

  @override
  void initState() {
    super.initState();

    Provider.of<AppState>(context, listen: false).initState(context).then((x) {
      UpdateStateRepository().update(context).then((value) {
        isNotSearching = true;
        //Movimientos cliente name and codigo interno
        Provider.of<AppState>(context, listen: false).addColumnsToMov();

        IO.Socket socket = IO.io(Strings.urlServer, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false
        });
        socket.connect();
        socket.onConnect((_) {
          print('connect');
        });

        final appStateProvider = Provider.of<AppState>(context, listen: false);
        //Equipos
        socket.on('new equipo',
            (data) => appStateProvider.addEquipo(Equipo.fromJson(data)));
        socket.on('edit equipo',
            (data) => appStateProvider.editEquipo(Equipo.fromJson(data)));
        socket.on('remove equipo',
            (id) => appStateProvider.removeEquipo(int.parse(id)));

        //Actas
        socket.on(
            'new acta',
            (data) =>
                appStateProvider.addActaSocket(Inspeccion.fromJson(data)));
        socket.on(
            'edit acta',
            (data) =>
                appStateProvider.editActaSocket(Inspeccion.fromJson(data)));
        socket.on('remove acta',
            (id) => appStateProvider.removeActaSocket(int.parse(id)));

        //Clientes

        socket.on('new cliente', (data) {
          print("new cliente");
          appStateProvider.addClienteSocket(Cliente.fromJson(data));
        });

        socket.on('edit cliente', (data) {
          print("edit cliente");
          appStateProvider.updateRutFromCliente(
              EditCliente.fromJson(Map<String, dynamic>.from(data)));
        });

        socket.on('remove cliente',
            (rut) => appStateProvider.removeClienteSocket(rut));

        //Movimientos
        socket.on(
            'new movimiento',
            (data) => appStateProvider
                .addMovimientoSocket(Movimiento.fromJson(data)));
        socket.on(
            'edit movimiento',
            (data) => appStateProvider
                .editMovimientoSocket(Movimiento.fromJson(data)));

        socket.on('remove movimiento',
            (id) => appStateProvider.removeMovimientoSocket(int.parse(id)));

        //Imagenes

        socket.on(
            'new modelo',
            (data) =>
                appStateProvider.addModeloSocket(ModeloImg.fromJson(data)));
        socket.on(
            'edit modelo',
            (data) =>
                appStateProvider.editModeloSocket(ModeloImg.fromJson(data)));
        socket.on('remove modelo',
            (modelo) => appStateProvider.removeModeloSocket(modelo));

        socket.onDisconnect((_) => print('disconnect'));
        socket.on('fromServer', (_) => print(_));
      });
    });

    Provider.of<ActaState>(context, listen: false).init();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.showInternetError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: const [
              Icon(
                Icons.dangerous_outlined,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Sin conexion a internet'),
            ],
          ),
        ));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ScrollController controller = ScrollController();

  TextEditingController? _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    equipos = Provider.of<AppState>(context).filterListEquipo;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (kDebugMode) {
      print("width: $width height $height");
    }

    var orientation = MediaQuery.of(context).orientation;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(800, 1340),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Scaffold(
      bottomNavigationBar: const BottomNavigator(),
      drawer: const MyDrawer(),
      body: Shortcuts(
        manager: LoggingShortcutManager(),
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const UpIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const DownIntent(),
        },
        child: Actions(
          dispatcher: LoggingActionDispatcher(),
          actions: {
            DownIntent: DownAction(controller),
            UpIntent: UpAction(controller),
          },
          child: Focus(
            autofocus: true,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/logo.svg",
                      height: 30,
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 15.h),
                        child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                onChanged:
                                    Provider.of<ActaState>(context).setId,
                                controller: _typeAheadController,
                                style: TextStyle(color: dark, fontSize: 20),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    hintText: 'Codigo interno',
                                    hintStyle: const TextStyle(fontSize: 20),
                                    border: const OutlineInputBorder(),
                                    isDense: true)),
                            suggestionsCallback: (pattern) {
                              List<Equipo> equiposSearch = [];

                              if (isNotSearching) {
                                equiposSearch = Provider.of<AppState>(context,
                                        listen: false)
                                    .equipos
                                    .where((element) => element.id
                                        .toString()
                                        .startsWith(pattern.toString()))
                                    .toList();
                                if (mounted) {
                                  print("filetr ${equiposSearch.length}");
                                  WidgetsBinding.instance
                                      ?.addPostFrameCallback((_) {
                                    Provider.of<AppState>(context,
                                            listen: false)
                                        .setFilter(equiposSearch);
                                  });
                                }

                                return equiposSearch.length >= 5
                                    ? equiposSearch.getRange(0, 5)
                                    : equiposSearch;
                              }
                              return List<Equipo>.empty();
                            },
                            itemBuilder: (context, suggestion) {
                              Equipo selectEquipo = suggestion as Equipo;

                              return ListTile(
                                title: Text(
                                  suggestion.id.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              suggestion as Equipo;
                              _typeAheadController?.text =
                                  suggestion.id.toString();

                              List<Equipo> equiposSearch = [];
                              equiposSearch =
                                  Provider.of<AppState>(context, listen: false)
                                      .equipos
                                      .where((element) =>
                                          element.id.toString() ==
                                          suggestion.id.toString())
                                      .toList();
                              Provider.of<AppState>(context, listen: false)
                                  .setFilter(equiposSearch);
                            })),
                    (equipos.isEmpty)
                        ? isNotSearching
                            ? Center(
                                child: Text(
                                  "No hay equipos registrados",
                                  style: TextStyle(color: dark, fontSize: 35),
                                ),
                              )
                            : Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Loading",
                                      style:
                                          TextStyle(color: dark, fontSize: 35),
                                    ),
                                  ],
                                ),
                              )
                        : Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              controller: controller,
                              scrollDirection: Axis.vertical,
                              itemCount: equipos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      searchController.clear();
                                      FocusScope.of(context).unfocus();
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetalleDispatcher(
                                                          equipo:
                                                              equipos[index])))
                                          .then((value) {});
                                    },
                                    child: CardEquipo(equipo: equipos[index]));
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: width < 600.0
                                          ? 1
                                          : orientation == Orientation.portrait
                                              ? 2
                                              : 4,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.97),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
