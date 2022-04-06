import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    super.invokeAction(action, intent, context);

    return null;
  }
}

/// A ShortcutManager that logs all keys that it hapndles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);

    if (result == KeyEventResult.handled) {}
    return result;
  }
}

/// TextEditingController.
class NextPageIntent extends Intent {
  const NextPageIntent();
}

class NextPageAction extends Action<NextPageIntent> {
  NextPageAction(this.controller, [this.callback]);
  final PageController controller;
  dynamic callback;

  @override
  Object? invoke(covariant NextPageIntent intent) {
    if (callback != null) {
      callback(1);
    }

    controller.nextPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
    return null;
  }
}

/// TextEditingController.
class PreviousPageIntent extends Intent {
  const PreviousPageIntent();
}

class PreviousPageAction extends Action<PreviousPageIntent> {
  PreviousPageAction(this.controller, [this.callback]);
  final PageController controller;
  dynamic callback;

  @override
  Object? invoke(covariant PreviousPageIntent intent) {
    if (callback != null) {
      callback(0);
    }
    controller.previousPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);

    return null;
  }
}

/// TextEditingController.
class DownIntent extends Intent {
  const DownIntent();
}

class DownAction extends Action<DownIntent> {
  DownAction(this.controller);
  var controller;

  @override
  Object? invoke(covariant DownIntent intent) {
    if (controller is DataGridController) {
      controller.scrollToVerticalOffset(controller.verticalOffset + 100.0,
          canAnimate: true);
    } else {
      controller.animateTo(controller.offset + 150,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }
    return null;
  }
}

/// TextEditingController.
class UpIntent extends Intent {
  const UpIntent();
}

class UpAction extends Action<UpIntent> {
  UpAction(this.controller);
  var controller;

  @override
  Object? invoke(covariant UpIntent intent) {
    if (controller is DataGridController) {
      controller.scrollToVerticalOffset(controller.verticalOffset - 200.0,
          canAnimate: true);
    } else {
      controller.animateTo(controller.offset - 150,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    }
    return null;
  }
}

class ClosePageIntent extends Intent {
  const ClosePageIntent();
}

class ClosePageAction extends Action<ClosePageIntent> {
  ClosePageAction(this.context, [this.callBack]);
  var context;
  dynamic callBack;

  @override
  Object? invoke(covariant ClosePageIntent intent) {
    if (callBack != null) {
      callBack();
    }
    Navigator.pop(context);

    return null;
  }
}
