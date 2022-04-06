import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/state/acta_state.dart';
import 'package:app_licman/ui/create_acta_pages/signature_page.dart';

import 'package:http/http.dart' as http;
import 'package:app_licman/plugins/dart_rut_form.dart';
import 'package:app_licman/widget/bottomNavigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:signature/signature.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../model/cola.dart';
import '../../model/inspeccion.dart';
import '../../model/state/common_var_state.dart';
import '../../model/state/app_state.dart';
import '../../services/generate_image_url.dart';
import '../../services/inspeccion_services.dart';
import '../../services/util.dart';

class actaGeneralPartTwoMobile extends StatefulWidget {
  const actaGeneralPartTwoMobile(
      {Key? key, this.editar, this.id, this.onlyCache, this.data})
      : super(key: key);
  final bool? editar;
  final int? id;
  final bool? onlyCache;
  final Uint8List? data;
  @override
  _actaGeneralPartTwoMobileState createState() =>
      _actaGeneralPartTwoMobileState();
}

enum ButtonState { init, loading, done }

class _actaGeneralPartTwoMobileState extends State<actaGeneralPartTwoMobile>
    with AutomaticKeepAliveClientMixin {
  bool isAnimating = true;
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  @override
  bool get wantKeepAlive => true; //
  TextEditingController? rutController;
  TextEditingController? nameController;
  TextEditingController? obvController;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  bool activar = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
    rutController = TextEditingController(
        text: Provider.of<ActaState>(context, listen: false).MapOfValue['rut']);
    nameController = TextEditingController(
        text:
            Provider.of<ActaState>(context, listen: false).MapOfValue['name']);
    obvController = TextEditingController(
        text: Provider.of<ActaState>(context, listen: false).MapOfValue['obv']);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (widget.editar != null) {
      activar = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    rutController?.dispose();
    nameController?.dispose();
    obvController?.dispose();
  }

  ButtonState buttonState = ButtonState.init;
  Widget buildSmallButton() {
    return Container(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )));
  }

  Widget buildSuccesButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: Colors.green,
        textStyle: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Enviado",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }

  bool showError = false;
  String message = '';
  bool changeFirm = false;

  final double paddingBetweenWidget = 10;

  final double fontSizeContent = 15;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final isDone = buttonState == ButtonState.done;
    final isStreched = isAnimating || buttonState == ButtonState.init;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            if (showError)
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.dangerous_outlined,
                          color: Colors.white,
                          size: 34,
                        ),
                        Expanded(
                          child: Text(
                            "Error: " + message,
                            style: TextStyle(
                                color: Colors.white, fontSize: fontSizeContent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            TextField(
              controller: rutController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]|k|K')),
                UpperCaseTextFormatter(),
              ],
              onChanged: (value) {
                Provider.of<ActaState>(context, listen: false).setRut(value);
                RUTValidator.formatFromTextController(rutController!);
              },
              style: TextStyle(color: dark, fontSize: fontSizeContent),
              keyboardType: TextInputType.name,
              maxLength: 12,
              decoration: const InputDecoration(
                  counterText: '',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: 'Rut',
                  prefixIcon: Icon(
                    Icons.person,
                    size: 30,
                  )),
            ),
            SizedBox(height: paddingBetweenWidget),
            TextField(
              controller: nameController,
              onChanged: Provider.of<ActaState>(context).setName,
              style: TextStyle(color: dark, fontSize: fontSizeContent),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  suffixIconConstraints: BoxConstraints(
                      maxHeight: 100,
                      minHeight: 60,
                      minWidth: 60,
                      maxWidth: 90),
                  hintText: 'Nombre',
                  suffixIcon: InkWell(
                    onTap: () async {
                      List<Point>? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignatureView(
                                    data: _controller.points,
                                    imageUrl: widget.editar != null
                                        ? Provider.of<ActaState>(context,
                                                listen: false)
                                            .MapOfValue['firmaUrl']
                                        : null,
                                    editar: widget.editar,
                                    onlyCache: widget.onlyCache,
                                    dataCache: widget.data,
                                  )));

                      if (result!.isNotEmpty) _controller.points = result;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 1.0),
                      child: Container(
                        color: dark,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
            SizedBox(height: paddingBetweenWidget),
            TextField(
              keyboardType: TextInputType.text,
              controller: obvController,
              onChanged: Provider.of<ActaState>(context).setObv,
              style: TextStyle(color: dark, fontSize: fontSizeContent),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                hintText: 'Observaciones',
              ),
            ),
            SizedBox(
              height: paddingBetweenWidget,
            ),
            widget.onlyCache != null
                ? Container(
                    width: double.infinity,
                    child: RoundedLoadingButton(
                      width: width,
                      height: 60,
                      successIcon: Icons.save,
                      failedIcon: Icons.clear,
                      borderRadius: 10,
                      onPressed: () async {
                        bool existError = await checkError();
                        if (existError) {
                          _btnController1.error();
                          await Future.delayed(Duration(milliseconds: 1000));
                          _btnController1.reset();
                          return;
                        }
                        final prov =
                            Provider.of<AppState>(context, listen: false);
                        Cola cola = prov.listCola[prov.indexCola];
                        Inspeccion acta =
                            Provider.of<ActaState>(context, listen: false)
                                .convertMapToObject("");
                        if (await _controller.toPngBytes() != null) {
                          cola.data = await _controller.toPngBytes();
                        }
                        cola.acta = acta;
                        cola.save();
                        await Future.delayed(Duration(milliseconds: 500));
                        _btnController1.success();
                        await Future.delayed(Duration(seconds: 1));
                        Navigator.pop(context);
                      },
                      controller: _btnController1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Guardar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                        ],
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                        width: buttonState == ButtonState.init ||
                                buttonState == ButtonState.done
                            ? width
                            : 70,
                        height: 50,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        onEnd: () => setState(() {
                              if (buttonState != ButtonState.done) {
                                isAnimating = !isAnimating;
                              }
                            }),
                        child: isStreched
                            ? OutlinedButton(
                                onPressed: () async {
                                  bool existError = await checkError();
                                  if (existError) {
                                    return;
                                  }
                                  setState(() {
                                    buttonState = ButtonState.loading;
                                  });
                                  enviarActaOnline();
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Enviar",
                                        style: TextStyle(
                                            fontSize: fontSizeContent,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ))
                            : buttonState == ButtonState.done
                                ? buildSuccesButton()
                                : buildSmallButton()),
                  )
          ],
        ),
      ),
    );
  }

  Future<String> getUrlImg() async {
    try {
      final Uint8List? data = await _controller.toPngBytes();

      //enviar la foto
      GenerateImageUrl generateImageUrl = GenerateImageUrl();
      await generateImageUrl.call(".png");

      String uploadUrl;
      if (generateImageUrl.isGenerated != null &&
          generateImageUrl.isGenerated!) {
        uploadUrl = generateImageUrl.uploadUrl!;
      } else {
        throw generateImageUrl.message!;
      }

      Uint8List imageInUnit8List = data!;
      final tempDir = await getTemporaryDirectory();

      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(imageInUnit8List);
      var response =
          await http.put(Uri.parse(uploadUrl), body: file.readAsBytesSync());

      return generateImageUrl.downloadUrl!;
    } catch (e) {
      return "";
    }
  }

  EnviarActaToEdit(Inspeccion acta) async {
    try {
      Inspeccion? result = await sendEditActa(acta);
      await Future.delayed(Duration(seconds: 1));
      if (result != null) {
        setState(() {
          buttonState = ButtonState.done;
        });
        await Future.delayed(Duration(seconds: 1));

        Provider.of<AppState>(context, listen: false).setActa(result);
        Provider.of<AppState>(context, listen: false)
            .setHorometro(acta.idEquipo!, acta.horometroActual!);
        Provider.of<CommonState>(context, listen: false).changeActaIndex(0);
        Provider.of<ActaState>(context, listen: false).reset();
        Navigator.pop(context);
      }
    } on SocketException {
      setState(() {
        buttonState = ButtonState.init;
        showError = true;
        message = "Sin conexion";
      });
    } on HttpException catch (e) {
      print(e.toString());
      setState(() {
        buttonState = ButtonState.init;
        showError = true;
        message = e.toString();
      });
    } catch (e) {
      setState(() {
        buttonState = ButtonState.init;
        showError = true;
        message = e.toString();
      });
    }
    return;
  }

  Future<void> enviarActaOnline() async {
    //Editar
    if (widget.editar != null) {
      String urlImg =
          Provider.of<ActaState>(context, listen: false).MapOfValue['firmaUrl'];
      if (await _controller.toPngBytes() != null) {
        urlImg = await getUrlImg();
      }
      Inspeccion acta = Provider.of<ActaState>(context, listen: false)
          .convertMapToObject(urlImg);
      acta.idInspeccion = widget.id;
      await EnviarActaToEdit(acta);
      return;
    }

    //Create
    String urlImg = await getUrlImg();
    Inspeccion acta = Provider.of<ActaState>(context, listen: false)
        .convertMapToObject(urlImg);
    try {
      final result = await sendActa(acta);
      if (result != null) {
        setState(() {
          buttonState = ButtonState.done;
        });
        await Future.delayed(Duration(seconds: 1));
        Provider.of<AppState>(context, listen: false).addActa(result);
        Provider.of<AppState>(context, listen: false)
            .setHorometro(acta.idEquipo!, acta.horometroActual!);
        Provider.of<CommonState>(context, listen: false).changeActaIndex(0);
        Provider.of<ActaState>(context, listen: false).reset();
        Navigator.pop(context);
      }
    } on SocketException {
      enviarActaOffline();
    } on HttpException catch (e) {
      setState(() {
        buttonState = ButtonState.init;
        showError = true;
        message = e.toString();
      });
    } catch (e) {
      setState(() {
        buttonState = ButtonState.init;
        showError = true;
        message = e.toString();
      });
    }
    return;
  }

  Future<void> enviarActaOffline() async {
    final Uint8List? data = await _controller.toPngBytes();
    var box = await Hive.openBox('cola');
    Inspeccion acta =
        Provider.of<ActaState>(context, listen: false).convertMapToObject("");

    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    String now = formatter.format(DateTime.now()); // 30/09/2021 15:54:30
    Cola cola = Cola(acta, now, "SIN ENVIAR", data);
    box.add(cola);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: Row(
        children: [
          Icon(
            Icons.dangerous,
            color: Colors.red,
          ),
          const SizedBox(width: 5),
          Text('Sin conexion a internet, se envio a la cola de actas',
              style: TextStyle(fontSize: 18)),
        ],
      ),
    ));
    Provider.of<AppState>(context, listen: false).addCola(cola);
    Provider.of<ActaState>(context, listen: false).reset();
    Navigator.pop(context);
  }

  Future<bool> checkError() async {
    String alturaLevante = Provider.of<ActaState>(context, listen: false)
        .MapOfValue['alturaLevante'];
    String horometroActual = Provider.of<ActaState>(context, listen: false)
        .MapOfValue['horometroActual'];
    //Inspeccion acta =Provider.of<ActaState>(context, listen: false).convertMapToObject("");
    final Uint8List? data = await _controller.toPngBytes();

    String? mastil = Provider.of<ActaState>(context, listen: false)
        .MapOfValue['mastilEquipo'];

    if (data == null && widget.editar == null) {
      setState(() {
        showError = true;
      });
      message = "Firma vacia";
      return true;
    }

    if (mastil == null) {
      setState(() {
        showError = true;
      });
      message = "Mastil vacio";
      return true;
    }

    if (alturaLevante == "") {
      setState(() {
        showError = true;
      });
      message = "Altura de levante vacia";
      return true;
    }
    if (horometroActual == "") {
      setState(() {
        showError = true;
      });
      message = "Campo horometro vacio";
      return true;
    }

    setState(() {
      showError = false;
    });
    return false;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

// class FirmPage extends StatefulWidget {
//   const FirmPage({ Key? key }) : super(key: key);

//   @override
//   State<FirmPage> createState() => _FirmPageState();
// }

// class _FirmPageState extends State<FirmPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Stack(
//         children: [
//           Signature(
//             controller: _controller,
//             height: 250,
//             backgroundColor: Colors.white,
//           ),
//           if (activar)
//           editar != null && !changeFirm
//                 ? Container(
//                     height: 250,
//                     width: double.infinity,
//                     color: Colors.black.withOpacity(0),
//                     child: onlyCache != null
//                         ? Image.memory(
//                            data!,
//                           )
//                         : Stack(
//                             children: [
//                               const Center(child: CircularProgressIndicator()),
//                               Center(
//                                 child: FadeInImage.memoryNetwork(
//                                   placeholder: kTransparentImage,
//                                   image: Provider.of<ActaState>(context,
//                                                   listen: false)
//                                               .MapOfValue['firmaUrl'] !=
//                                           null
//                                       ? Provider.of<ActaState>(context,
//                                               listen: false)
//                                           .MapOfValue['firmaUrl']
//                                       : "",
//                                 ),
//                               ),
//                             ],
//                           ),
//                   )
//                 : Container(
//                     height: 250,
//                     width: double.infinity,
//                     color: Colors.black.withOpacity(0),
//                   ),
//         ],
//       ),
//       Container(
//         decoration: BoxDecoration(
//             color: dark, border: Border.all(color: Colors.white, width: 0.5)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             //SHOW EXPORTED IMAGE IN NEW ROUTE
//             IconButton(
//               icon: const Icon(Icons.check),
//               color: Colors.white,
//               onPressed: () async {
//                 if (_controller.isNotEmpty) {
//                   final Uint8List? data = await _controller.toPngBytes();

//                   if (data != null) {
//                     callBack();
//                     setState(() {
//                       activar = true;
//                       if (widget.editar != null) {
//                         changeFirm = true;
//                       }
//                     });
//                   }
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.undo),
//               color: Colors.white,
//               onPressed: () {
//                 setState(() => _controller.undo());
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.redo),
//               color: Colors.white,
//               onPressed: () {
//                 setState(() => _controller.redo());
//               },
//             ),
//             //CLEAR CANVAS
//             IconButton(
//               icon: const Icon(Icons.clear),
//               color: Colors.white,
//               onPressed: () {
//                 setState(() {
//                   activar = false;
//                   _controller.clear();
//                 });
//               },
//             ),
//           ],
//         ),
//       )
//     ]);
//   }
// }


