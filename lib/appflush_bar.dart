import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AppFlushBar {
  static Flushbar success(BuildContext context, {String? message}) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      duration: const Duration(seconds: 4),
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.slowMiddle,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check, color: Colors.white),
      messageText: Text(
        message ?? "",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    )..show(context);
  }

  static Flushbar error(BuildContext context, {String? message}) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      duration: const Duration(seconds: 4),
      reverseAnimationCurve: Curves.linearToEaseOut,
      forwardAnimationCurve: Curves.linearToEaseOut,
      backgroundColor: const Color(0xFFFB003F),
      icon: const Icon(Icons.error, color: Colors.white),
      messageText: Text(
        message ?? "",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    )..show(context);
  }
}
