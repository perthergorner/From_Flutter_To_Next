import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirihare/common/assets.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/model/sub_menu_model.dart';
import 'package:kirihare/utils/log_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SelfCheckOnMindAdapter {
  Widget menuItem(SubMenuModel model, int index) {
    return InkWell(
      onTap: () async {
        if (model.value.isEmpty) return;
        try {
          launchUrl(Uri.parse(model.value),mode: LaunchMode.externalApplication);
        } catch (e) {
          print(e);
        }
      },
      child:  FadeInImage.assetNetwork(placeholder: Assets.DEFAULT_IMG_PATH, image: model.imgUrl, fit: BoxFit.fill)
    );
  }
}