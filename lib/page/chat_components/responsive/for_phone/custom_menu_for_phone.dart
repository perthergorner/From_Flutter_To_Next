import 'package:flutter/material.dart';
import 'package:kirihare/common/AppColors.dart';
import 'package:kirihare/common/api.dart';
import 'package:kirihare/model/rich_menu.dart';

class CustomMenuForPhone extends StatelessWidget {
  CustomMenuForPhone({Key? key, required this.showMenu, this.richMenuModel, required this.callBack})
      : super(key: key);
  final bool showMenu;
  final RichMenuModel? richMenuModel;
  final void Function(int) callBack;
  final GlobalKey stickyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (richMenuModel == null) return Container();
    return Visibility(
      visible: showMenu,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(color: AppColors.colorMenuBg),
        child: GestureDetector(
          key: stickyKey,
          onTapDown: (details) {
            var height = stickyKey.currentContext?.size?.height;
            var width = stickyKey.currentContext?.size?.width;
            var x = details.localPosition.dx;
            var y = details.localPosition.dy;
            if (width == null || height == null) {
              return;
            }
            var index = richMenuModel!.findIndex(width, height, x, y);
            if (index > -1) {
              callBack(index);
            }
          },
          child: Image.network(account!.menuImageUrl!),
        ),
      ),
    );
  }
}
