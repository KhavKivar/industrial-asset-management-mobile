import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/equipo.dart';
import 'package:app_licman/model/state/actaState.dart';
import 'package:app_licman/model/state/commonVarState.dart';
import 'package:app_licman/model/state/equipoState.dart';
import 'package:app_licman/ui/tabla_actas/all_actas_page.dart';

import 'package:app_licman/widget/bottomNavigator.dart';
import 'package:app_licman/widget/card_equipo_widget.dart';
import 'package:app_licman/widget/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../Repository/updateResourcesRepository.dart';
import '../main.dart';
import 'ui_creacion_acta/acta_general_page.dart';
import 'card_equipo_detalle.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  int choose = -1;
  double witt = 300;
  final searchController = TextEditingController();
  bool select = false;
  List equipos = [];

  @override
  void initState() {
    super.initState();

    Provider.of<EquipoState>(context, listen: false)
        .initState(context)
        .then((x) {
      UpdateStateRepository().update(context);
    });
    Provider.of<ActaState>(context, listen: false).init();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    equipos = Provider.of<EquipoState>(context).filterListEquipo;
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    print("width: ${width} heighh ${height}");

    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      bottomNavigationBar: const BottomNavigator(),
      drawer: MyDrawer(),
      body: Shortcuts(
        manager: LoggingShortcutManager(),
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const  upIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const downIntent(),

        },

        child: Actions(
          dispatcher: LoggingActionDispatcher(),
          actions: {
            downIntent: downAction(controller),
            upIntent: upAction(controller),

          },
          child: Focus(
            autofocus: true,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/logo.svg",
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                      child: Container(
                        height: 55,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar equipos..',
                            prefixIcon: Icon(Icons.search),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onChanged: (value) {
                            if (value == "") {
                              Provider.of<EquipoState>(context, listen: false)
                                  .setFilter(
                                      Provider.of<EquipoState>(context, listen: false)
                                          .equipos);
                            } else {
                              List<Equipo> equiposSearch =
                                  Provider.of<EquipoState>(context, listen: false)
                                      .equipos
                                      .where((element) =>
                                          element.id.toString().startsWith(value) ||
                                          element.tipo
                                              .toLowerCase()
                                              .startsWith(value.toLowerCase()) ||
                                          element.marca
                                              .toLowerCase()
                                              .startsWith(value.toLowerCase()) ||
                                          element.modelo
                                              .toLowerCase()
                                              .startsWith(value.toLowerCase()))
                                      .toList();
                              Provider.of<EquipoState>(context, listen: false)
                                  .setFilter(equiposSearch);
                            }
                          },
                        ),
                      ),
                    ),
                    (equipos.isEmpty)
                        ? Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Loading",
                                  style: TextStyle(color: dark, fontSize: 35),
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
                                              builder: (context) => cardEquipoDetalle(
                                                  equipo: equipos[index]))).then(
                                          (value) {
                                        Provider.of<EquipoState>(context,
                                                listen: false)
                                            .setFilter(Provider.of<EquipoState>(
                                                    context,
                                                    listen: false)
                                                .equipos);
                                      });
                                    },
                                    child: CardEquipo(equipo: equipos[index]));
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      orientation == Orientation.portrait ? 2 : 4,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 0.98),
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

/*
*  Expanded(
                    child: LayoutGrid(columnSizes:   [1.fr, 1.fr]
                      , rowSizes: [auto, auto],
                      rowGap: 40, // equivalent to mainAxisSpacing
                      columnGap: 24,
                      children: [
                          for (var i = 0; i < equipos.length; i++)
                            Card(
                              child: Text("heloo",style: TextStyle(color: Colors.red),
                              ),
                            )
                        ],
                    )
                  ),
* */
/**
 *
 *GridView.builder(
    shrinkWrap: true,
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
    cardEquipoDetalle(
    equipo: equipos[index]))

    ).then((value){

    Provider.of<EquipoState>(context, listen: false)
    .setFilter(Provider.of<EquipoState>(context,listen: false).equipos);
    });
    },
    child:  CardEquipo(equipo: equipos[index]));
    },
    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(

    crossAxisCount: orientation == Orientation.landscape ? 4: 2,crossAxisSpacing: 5,
    mainAxisSpacing: 5,
    mainAxisExtent: 400  ,



    ),

    ),
 */
