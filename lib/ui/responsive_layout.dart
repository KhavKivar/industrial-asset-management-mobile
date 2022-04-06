import 'package:app_licman/const/breakpoints.dart';
import 'package:flutter/cupertino.dart';

String getDevice(context) {
  final widthDevice = MediaQuery.of(context).size.width;
  if (widthDevice < kTabletBreakPoints) {
    return 'mobile';
  } else if (widthDevice >= kTabletBreakPoints &&
      widthDevice < kDestopBreakPoints) {
    return 'tablet';
  } else {
    return 'desktop';
  }
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {Key? key,
      required this.mobileBody,
      required this.tabletBody,
      required this.desktopBody})
      : super(key: key);
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, dimens) {
      if (dimens.maxWidth < kTabletBreakPoints) {
        return mobileBody;
      } else if (dimens.maxWidth >= kTabletBreakPoints &&
          dimens.maxWidth < kDestopBreakPoints) {
        return tabletBody;
      }
      return desktopBody;
    });
  }
}
