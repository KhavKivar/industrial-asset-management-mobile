import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../../const/Colors.dart';

/// example widget showing how to use signature widget
class SignatureView extends StatefulWidget {
  const SignatureView(
      {Key? key,
      this.data,
      this.imageUrl,
      this.editar,
      this.onlyCache,
      this.dataCache})
      : super(key: key);
  final data;

  final String? imageUrl;
  final editar;
  final onlyCache;
  final dataCache;

  @override
  _SignatureViewState createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.white,
    exportBackgroundColor: Colors.black,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  bool activar = false;
  bool changeFirm = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
    if (widget.data != null) _controller.points = widget.data;
    if (widget.editar != null) {
      if (widget.data.length > 0) {
        activar = false;
      } else {
        activar = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height - 200;
    return WillPopScope(
      onWillPop: () async {
        final data = _controller.points;

        Navigator.pop(context, data);
        return true;
      },
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.white),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  final data = _controller.points;

                  Navigator.pop(context, data);
                }),
            backgroundColor: dark,
            title: const Text('Firma'),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  //SIGNATURE CANVAS
                  Signature(
                    controller: _controller,
                    height: altura,
                    backgroundColor: Colors.black,
                  ),
                  if (activar)
                    widget.editar != null
                        ? Container(
                            height: altura,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0),
                            child: widget.onlyCache != null
                                ? Image.memory(
                                    widget.dataCache!,
                                  )
                                : Center(
                                    child: CachedNetworkImage(
                                      width: double.infinity,
                                      fit: BoxFit.fitWidth,
                                      imageUrl: widget.imageUrl ?? "",
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ))
                        : Container(
                            height: altura,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0),
                          ),
                ],
              ),
              Container(
                decoration: BoxDecoration(color: yellowBackground),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //SHOW EXPORTED IMAGE IN NEW ROUTE
                    IconButton(
                      icon: const Icon(Icons.check),
                      color: dark,
                      onPressed: () async {
                        if (_controller.isNotEmpty) {
                          final data = _controller.points;

                          Navigator.pop(context, data);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.undo),
                      color: dark,
                      onPressed: () {
                        setState(() => _controller.undo());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      color: dark,
                      onPressed: () {
                        setState(() => _controller.redo());
                      },
                    ),
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: dark,
                      onPressed: () {
                        setState(() {
                          activar = false;
                          _controller.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
