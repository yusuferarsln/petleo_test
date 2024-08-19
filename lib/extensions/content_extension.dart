import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }

  void showSnackBar(String message) {
    final duration = Duration(milliseconds: max(message.length * 50, 1000));
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
    ));
  }

  //* Navigation *//

  void go(Widget page, {bool clear = false}) {
    final route = CupertinoPageRoute(builder: (_) => page);

    clear
        ? Navigator.of(this).pushAndRemoveUntil(route, (route) => false)
        : Navigator.of(this).push(route);
  }

  void replace(Widget page) {
    Navigator.of(this)
        .pushReplacement(CupertinoPageRoute(builder: (_) => page));
  }

  void back() {
    return Navigator.of(this).pop();
  }
}
