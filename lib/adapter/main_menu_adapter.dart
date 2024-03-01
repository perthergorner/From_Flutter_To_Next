import 'package:flutter/material.dart';
import 'package:kirihare/common/assets.dart';
import 'package:kirihare/model/main_menu_model.dart';
class MainMenuAdapter {
  Widget menuItem(MainMenuModel model,void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: FadeInImage.assetNetwork(placeholder: Assets.DEFAULT_IMG_PATH, image: model.imgUrl, fit: BoxFit.fill)
    );
  }
}