import 'package:flutter/material.dart';
import 'package:kirihare/adapter/main_menu_adapter.dart';
import 'package:kirihare/common/AppColors.dart';
import 'package:kirihare/model/main_menu_model.dart';
import 'package:fbroadcast/fbroadcast.dart';

class CustomMenuForPC extends StatelessWidget {
  const CustomMenuForPC({
    Key? key,
    required this.mainMenuList,
    required this.callBack
  }) : super(key: key);
  final List<MainMenuModel> mainMenuList;
  final void Function(int) callBack;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Container(
      width: width * 0.15,
      padding: const EdgeInsets.only(
          top: 20, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(color: AppColors.customMenuBg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.1,
            child: Text("KIRIHARE"),
          ),
          Container(
            height: height * 0.1,
            padding: const EdgeInsets.all(8.0),
            child: Text("メニュー"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: height * 0.75,
              child: ListView.builder(
                itemCount: mainMenuList.length,
                itemBuilder: (_,index) => 
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0
                    ),
                    child: MainMenuAdapter().menuItem(
                      mainMenuList[index], 
                      () => callBack(index)
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}