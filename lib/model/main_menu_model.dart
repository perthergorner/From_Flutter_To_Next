import 'package:kirihare/common/constants.dart';

class MainMenuModel {
  String type = '';
  String value = '';
  String imgUrl = '';

  MainMenuModel();

  factory MainMenuModel.fromJSON(Map<String, dynamic> res){
    MainMenuModel model = new MainMenuModel();
    model.type = res[Constants.type];
    model.value = res[Constants.VALUE];
    model.imgUrl = res[Constants.IMG_URL];
    return model;
  }
}