import 'dart:convert';

import 'package:kirihare/common/constants.dart';
import 'package:kirihare/utils/log_utils.dart';

class HealthRoomModel {
  String type = '';
  String value = '';
  String title = '';
  String imgUrl = '';

  List<PostbackModel> postbackList = [];

  HealthRoomModel();

  factory HealthRoomModel.fromJSON (List<dynamic> res ) {

    Map<String, dynamic> item_1 = res[0];
    HealthRoomModel model = new HealthRoomModel();
    model.type = item_1[Constants.type];
    model.value = item_1[Constants.VALUE];
    model.imgUrl = item_1[Constants.IMG_URL];

    Map<String, dynamic> item_2 = res[1];
    model.title = item_2[Constants.TITLE];

    var jsonList_2 = item_2[Constants.LIST] as List;
    jsonList_2.forEach((element) {
      PostbackModel postbackModel = new PostbackModel();
      postbackModel.label = element[Constants.LABLE];
      postbackModel.postback = element[Constants.POSTBACK];
      postbackModel.type = element[Constants.type];

      model.postbackList.add(postbackModel);
    });


    return model;
  }
}

class PostbackModel {
  String label = '';
  String postback = '';
  String type = '';

  PostbackModel();

  factory PostbackModel.fromJSON(Map<String, dynamic> res){
    PostbackModel model = new PostbackModel();
    model.label = res[Constants.LABLE];
    model.postback = res[Constants.POSTBACK];
    model.type = res[Constants.type];

    return model;
  }
}