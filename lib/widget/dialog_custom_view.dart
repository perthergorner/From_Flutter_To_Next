import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {String title = "",
      String content = "",
      String okBtnText = "はい",
      String cancelBtnText = "キャンセル",
      Function()? okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: Text(okBtnText),
                onPressed: okBtnFunction ?? () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(cancelBtnText),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
