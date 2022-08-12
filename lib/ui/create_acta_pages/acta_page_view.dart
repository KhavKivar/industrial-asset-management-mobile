import 'dart:typed_data';

import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/state/common_var_state.dart';
import 'package:app_licman/ui/create_acta_pages/acta_general_part_2_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../intent_file.dart';
import '../../model/state/acta_state.dart';
import '../../widget/row_navigator_widget.dart';
import 'acta_general_page.dart';
import 'acta_general_part_2_page.dart';

class ActaPageView extends StatefulWidget {
  const ActaPageView(
      {Key? key,
      this.edit,
      int? this.id,
      this.onlyCacheSave,
      this.data,
      this.device})
      : super(key: key);
  final bool? edit;
  final int? id;
  final bool? onlyCacheSave;
  final Uint8List? data;
  final String? device;
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
    if (_focusNode == null) {
      FocusScope.of(context).previousFocus();
    }
  }

  callBack(int value) {
    setState(() {
      Provider.of<CommonState>(context, listen: false).changeActaIndex(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          if (widget.edit != null) {
            Provider.of<ActaState>(context, listen: false).reset();
          }
          Provider.of<CommonState>(context, listen: false).changeActaIndex(0);
          return Future<bool>.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: dark,
            title: Text(
              widget.edit != null ? "Editar acta" : "Creacion de acta",
              style: TextStyle(),
            ),
            leading: BackButton(
              onPressed: () {
                if (widget.edit != null) {
                  Provider.of<ActaState>(context, listen: false).reset();
                }
                Provider.of<CommonState>(context, listen: false)
                    .changeActaIndex(0);
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Shortcuts(
            manager: LoggingShortcutManager(),
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.arrowRight):
                  const NextPageIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                  const PreviousPageIntent(),
              LogicalKeySet(LogicalKeyboardKey.escape): const ClosePageIntent()
            },
            child: Actions(
              dispatcher: LoggingActionDispatcher(),
              actions: {
                NextPageIntent: NextPageAction(controller, callBack),
                PreviousPageIntent: PreviousPageAction(controller, callBack),
                ClosePageIntent: ClosePageAction(context, callBackClose)
              },
              child: FocusScope(
                autofocus: true,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                            padding: widget.device == 'mobile'
                                ? EdgeInsets.only(left: 10, right: 10, top: 10)
                                : EdgeInsets.only(left: 20, right: 20, top: 15),
                            child: TopNavigator(
                              device: widget.device,
                              controller: controller,
                            )),
                        Expanded(
                          child: PageView(
                            controller: controller,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              SingleChildScrollView(
                                child: ActaGeneral(
                                  device: widget.device,
                                ),
                              ),
                              widget.device.toString() == 'mobile'
                                  ? actaGeneralPartTwoMobile(
                                      editar: widget.edit,
                                      id: widget.id,
                                      onlyCache: widget.onlyCacheSave,
                                      data: widget.data)
                                  : actaGeneralPartTwo(
                                      device: widget.device.toString(),
                                      editar: widget.edit,
                                      id: widget.id,
                                      onlyCache: widget.onlyCacheSave,
                                      data: widget.data),
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
      ),
    );
  }

  callBackClose() {
    if (widget.edit != null) {
      Provider.of<ActaState>(context, listen: false).reset();
    } else {}
  }
}

class TopNavigator extends StatefulWidget {
  const TopNavigator({Key? key, required this.controller, this.device})
      : super(key: key);
  final PageController controller;
  final String? device;

  @override
  _TopNavigatorState createState() => _TopNavigatorState();
}

class _TopNavigatorState extends State<TopNavigator> {
  int select = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    select = Provider.of<CommonState>(context).actaSelectItem;
  }

  final double fontSizeNav = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.device == 'mobile' ? 55 : 60,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          _RowNavigatorItem(
            device: widget.device,
            itemValue: 0,
            onTap: () {
              Provider.of<CommonState>(context, listen: false)
                  .changeActaIndex(0);
              widget.controller.animateToPage(0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            select: select,
          ),
          _RowNavigatorItem(
            device: widget.device,
            itemValue: 1,
            onTap: () {
              Provider.of<CommonState>(context, listen: false)
                  .changeActaIndex(1);
              widget.controller.animateToPage(1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            select: select,
          )
        ],
      ),
    );
  }
}

class _RowNavigatorItem extends StatelessWidget {
  _RowNavigatorItem(
      {Key? key,
      required this.select,
      required this.itemValue,
      required this.onTap,
      this.device})
      : super(key: key);
  final double fontSizeNav = 20;
  final double fontSizeNavMobile = 17;
  final int select;
  final int itemValue;
  final onTap;
  final device;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: select == itemValue ? Colors.blueAccent : dark,
              borderRadius: itemValue == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
            ),
            child: RowNavigator(
              device: device,
              iconData: itemValue == 0 ? Icons.content_paste : Icons.edit,
              title: itemValue == 0 ? "Acta" : "Datos del cliente",
              fontSizeText:
                  device == 'mobile' ? fontSizeNavMobile : fontSizeNav,
            )),
      ),
    );
  }
}
