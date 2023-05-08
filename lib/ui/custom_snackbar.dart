import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    Key? key,
    required Widget message,
    String btnLabel = 'OK',
    Duration duration = const Duration(seconds: 2),
    void Function()? onOk}) : super(
        key: key,
        content: message,
        backgroundColor: Colors.white,
        duration: duration,
        action: SnackBarAction(
          label: btnLabel,
          onPressed: () {if (onOk != null) {
            onOk();}
          }),
      );
}
