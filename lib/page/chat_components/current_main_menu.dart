// flutter
import 'package:flutter/material.dart';
import 'package:kirihare/adapter/main_menu_adapter.dart';
import 'package:kirihare/common/shadow.dart';
import 'package:kirihare/model/main_menu_model.dart';
// 
class CurrentMainMenu extends StatelessWidget {
  const CurrentMainMenu({
    Key? key,
    required this.currentMainMenuModel,
  }) : super(key: key);
  final MainMenuModel? currentMainMenuModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.22;
    final height = size.height * 0.18;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: basicShadow
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "現在選択中",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if(currentMainMenuModel != null) 
              Center(
                child: SizedBox(
                  width: width * 0.6,
                  height: height * 0.5,
                  child: MainMenuAdapter().menuItem(
                    currentMainMenuModel!,
                    null
                  ),
                ),
              )
          ],
        )
      ),
    );
  }
}