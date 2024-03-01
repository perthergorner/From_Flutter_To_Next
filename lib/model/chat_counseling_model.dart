import 'package:kirihare/common/constants.dart';

class ChatCounselingModel {
  String title = '';
  String postbackMessage = '';
  String type = '';

  ChatCounselingModel();

  factory ChatCounselingModel.fromJSON(Map<String, dynamic> res) {
    ChatCounselingModel model = new ChatCounselingModel();

    model.title = res[Constants.TITLE];
    model.postbackMessage = res[Constants.POSTBACK_MESSAGE];
    model.type = res[Constants.type];

    return model;
  }
}