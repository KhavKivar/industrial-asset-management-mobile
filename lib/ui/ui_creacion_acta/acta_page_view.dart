import 'dart:typed_data';

import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/state/commonVarState.dart';
import 'package:app_licman/ui/ui_creacion_acta/acta_general_page.dart';
import 'package:app_licman/ui/ui_creacion_acta/acta_general_part_2_page.dart';

import 'package:app_licman/widget/bottomNavigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/state/actaState.dart';
import '../tabla_actas/all_actas_page.dart';

class ActaPageView extends StatefulWidget {
  const ActaPageView({Key? key, this.edit, int? this.id, this.onlyCacheSave, this.data}) : super(key: key);
  final bool? edit;
  final int? id;
  final bool? onlyCacheSave;
  final Uint8List? data;
  @override
  _ActaPageViewState createState() => _ActaPageViewState();
}



class _ActaPageViewState extends State<ActaPageView> {
  final PageController controller = PageController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    FocusNode? _focusNode = FocusScope.of(context).focusedChild;
    if(_focusNode == null){

      FocusScope.of(context).previousFocus();

    }


  }
  int select = 0;

  callBack(int value){
    setState(() {
      Provider.of<CommonState>(context, listen: false)
          .changeActaIndex(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: dark,
          title: Text(
            widget.edit != null ? "Editar acta" : "Creacion de acta",
            style: TextStyle(),
          ),
          leading: BackButton(onPressed: (){
              if(widget.edit !=null){
                Provider.of<ActaState>(context, listen: false).reset();
              }

             Navigator.of(context).pop();

          },),
        ),
        body: Shortcuts(
          manager: LoggingShortcutManager(),
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.arrowRight): const nextPageIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowLeft): const previousPageIntent(),
            LogicalKeySet(LogicalKeyboardKey.escape): const closePageIntent()
          },
          child: Actions(
            dispatcher: LoggingActionDispatcher(),
            actions: {
              nextPageIntent: nextPageAction(controller,callBack),
              previousPageIntent: previousPageAction(controller,callBack),
              closePageIntent: closePageAction(context,callBack_close)
            },
            child: FocusScope(
              autofocus: true,
              onFocusChange: (hasFocus) {

                FocusNode? _focusNode = FocusScope.of(context).focusedChild;

                if(hasFocus) {
                  // do stuff
                }
              },

              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 30, right: 30, top: 10),
                          child: TopNavigator(
                            controller: controller, select: select,
                          )),
                      Expanded(
                        child: PageView(
                          controller: controller,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            SingleChildScrollView(
                              child: ActaGeneral(),
                            ),
                            actaGeneralPartTwo(
                              editar: widget.edit,
                              id: widget.id,
                              onlyCache: widget.onlyCacheSave,
                              data:widget.data
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  callBack_close() {

    Provider.of<ActaState>(context, listen: false).reset();
  }
}

class TopNavigator extends StatefulWidget {
   TopNavigator({Key? key, required this.controller,required this.select}) : super(key: key);
  final PageController controller;
  int select;
  @override
  _TopNavigatorState createState() => _TopNavigatorState();
}

class _TopNavigatorState extends State<TopNavigator> {


  @override
  void didChangeDependencies() {
    widget.select = Provider.of<CommonState>(context).actaSelectItem;
  }

  final double fontSizeNav = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              Provider.of<CommonState>(context, listen: false)
                  .changeActaIndex(0);
              widget.controller.animateToPage(0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    color: widget.select == 0 ? Colors.blueAccent : dark,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )),
                child: RowNavigator(
                  iconData: Icons.content_paste,
                  title: "Acta",
                  fontSizeText: fontSizeNav,
                )),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              Provider.of<CommonState>(context, listen: false)
                  .changeActaIndex(1);
              widget.controller.animateToPage(1,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: widget.select == 1 ? Colors.blueAccent : dark,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: RowNavigator(
                  iconData: Icons.person,
                  title: "Datos del cliente",
                  fontSizeText: fontSizeNav,
                )),
          )),
        ],
      ),
    );
  }
}

class RowNavigator extends StatelessWidget {
  const RowNavigator(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.fontSizeText})
      : super(key: key);
  final String title;
  final IconData iconData;
  final double fontSizeText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Icon(
          iconData,
          color: Colors.white,
          size: 30,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(title,
              style: TextStyle(color: Colors.white, fontSize: fontSizeText),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
/*
*   Expanded(
              child: GestureDetector(
            onTap: () {
              Provider.of<CommonState>(context, listen: false)
                  .changeActaIndex(2);
              widget.controller.animateToPage(2,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color: select == 2 ? Colors.blueAccent : dark,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  )),
              child: RowNavigator(
                iconData: Icons.edit,
                title: "Firma",
                fontSizeText: fontSizeNav,
              ),
            ),
          ))
* */
