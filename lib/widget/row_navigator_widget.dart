import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RowNavigator extends StatelessWidget {
  const RowNavigator(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.fontSizeText,
      this.device})
      : super(key: key);
  final String title;
  final IconData iconData;
  final double fontSizeText;
  final String? device;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        if (device != 'mobile')
          Icon(
            iconData,
            color: Colors.white,
            size: 30,
          ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: AutoSizeText(title,
              style: TextStyle(color: Colors.white, fontSize: fontSizeText),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
