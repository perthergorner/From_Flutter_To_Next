import 'package:flutter/material.dart';
import 'package:kirihare/common/api.dart';
import 'package:kirihare/page/verry_code.dart';
import 'package:kirihare/common/common.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({Key? key, this.size}) : super(key: key);
  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _getApi,
      icon: Icon(
        Icons.help_outline,
        size: size,
      ),
    );
  }
  _getApi(){
    LoginAPI().getHelpUrl(Common.userId).then((value) {
      print("getHelpUrl: ${value}");
      if(value != null){
        launchUrlString(value);
      }
    });
  }
}
