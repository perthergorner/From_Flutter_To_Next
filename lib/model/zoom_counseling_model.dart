import 'package:kirihare/common/constants.dart';

class ZoomCounselingModel {
  String title = '';
  String postbackMessage = '';
  String type = '';

  ZoomCounselingModel();

  factory ZoomCounselingModel.fromJSON(Map<String, dynamic> res){
    ZoomCounselingModel model = new ZoomCounselingModel();
    model.title = res[Constants.TITLE];
    model.postbackMessage = res[Constants.POSTBACK_MESSAGE];
    model.type = res[Constants.type];
    return model;
  }
}