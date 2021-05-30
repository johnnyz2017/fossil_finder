import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

successToast(String message, {int timeIosWeb = 2}){
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: timeIosWeb,
    gravity: ToastGravity.CENTER,
    textColor: Colors.grey);
  print('successToast');
}

errorToast(String message, {int timeIosWeb = 2}){
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: timeIosWeb,
    gravity: ToastGravity.CENTER,
    textColor: Colors.red);
  print('errorToast');
}

Flushbar showSuccessToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Success',
    message: message,
    icon: Icon(
      Icons.check,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.green[600], Colors.green[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

Flushbar showErrorToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Error',
    message: message,
    icon: Icon(
      Icons.error,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.red[600], Colors.red[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}
