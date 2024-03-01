import 'package:kirihare/common/constants.dart';

class SubMenuModel {
  String type = '';
  String value = '';
  String imgUrl = '';

  SubMenuModel();

  factory SubMenuModel.fromJSON(Map<dynamic, dynamic> res) {
    SubMenuModel model = new SubMenuModel();
    model.type = res[Constants.type];
    model.value = res[Constants.VALUE];
    model.imgUrl = res[Constants.IMG_URL];
    return model;
  }

  Map<String, dynamic> toJSON() =>
      {Constants.type: type, Constants.value: value, Constants.imgUrl: imgUrl};
}
