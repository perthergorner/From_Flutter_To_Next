import 'package:flutter/material.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/model/health_room_model.dart';
import 'package:kirihare/model/sub_menu_model.dart';

class MsgModel {
  String userId = '';
  String? msg;
  String type = '';
  String itemChatCounseling = '';
  String itemZoomCounseling = '';
  String itemHarassmentTitle = '';
  String itemHarassmentContent = '';
  String itemHarassmentButton1 = '';
  String itemHarassmentButton2 = '';
  String itemHarassmentPostback1 = '';
  String itemHarassmentPostback2 = '';
  String itemHarassmentConsultationTitle = '';
  String itemHarassmentConsultationContent = '';
  String itemHarassmentTimeMsg1 = '';
  String itemHarassmentTimeMsg2 = '';
  List<SubMenuModel> menuSelfCheckOnMindList = [];
  List<SubMenuModel> menuStretchingList = [];
  String freqTitle = '';
  String freqMsg_1 = '';
  String freqPostback_1 = '';
  String freqMsg_2 = '';
  String freqPostback_2 = '';
  String harassment_occurrence_title = '';
  String harassment_occurrence_breaking_time = '';
  String harassment_occurrence_after_work = '';
  String harassment_occurrence_holiday = '';
  String harassment_occurrence_others = '';
  List<PostbackModel> postbackList = [];
  String postback = '';
  int rowIndex = 0;
  String? textSearch;
  Color? colorSelect;
  bool selectFlag = false;
  MsgModel();

  MsgModel fromJSON(Map<String, dynamic> res) {
    MsgModel model = new MsgModel();

    model.userId = res[Constants.userId];
    model.msg = res[Constants.msg] ?? "";
    model.type = res[Constants.type];
    model.itemChatCounseling = res[Constants.itemChatCounseling];
    model.itemZoomCounseling = res[Constants.itemZoomCounseling];
    model.itemHarassmentTitle = res[Constants.itemHarassmentTitle];
    model.itemHarassmentContent = res[Constants.itemHarassmentContent];
    model.itemHarassmentButton1 = res[Constants.itemHarassmentButton1];
    model.itemHarassmentButton2 = res[Constants.itemHarassmentButton2];
    model.itemHarassmentPostback1 = res[Constants.itemHarassmentPostback1];
    model.itemHarassmentPostback2 = res[Constants.itemHarassmentPostback2];
    model.itemHarassmentConsultationTitle =
        res[Constants.itemHarassmentConsultationTitle];
    model.itemHarassmentConsultationContent =
        res[Constants.itemHarassmentConsultationContent];
    model.itemHarassmentTimeMsg2 = res[Constants.itemHarassmentTimeMsg2];
    model.itemHarassmentTimeMsg1 = res[Constants.itemHarassmentTimeMsg1];
    model.menuSelfCheckOnMindList
        .addAll(getSubMenuList(res[Constants.menuSelfCheckOnMindList] as List));
    model.menuStretchingList
        .addAll(getSubMenuList(res[Constants.menuStretchingList] as List));
    model.freqTitle = res[Constants.freqTitle];
    model.freqMsg_1 = res["freqMsg_1"];
    model.freqPostback_1 = res["freqPostback_1"];
    model.freqMsg_2 = res["freqMsg_2"];
    model.freqPostback_2 = res["freqPostback_2"];
    model.harassment_occurrence_title =
        res[Constants.harassment_occurrence_title];
    model.harassment_occurrence_breaking_time =
        res[Constants.harassment_occurrence_breaking_time];
    model.harassment_occurrence_after_work =
        res[Constants.harassment_occurrence_after_work];
    model.harassment_occurrence_holiday =
        res[Constants.harassment_occurrence_holiday];
    model.harassment_occurrence_others =
        res[Constants.harassment_occurrence_others];
    model.rowIndex = res[Constants.rowIndex];
    model.postback = res['postback'] ?? "";
    model.postbackList
        .addAll(getSubMenuListPostbackModel(res["postbacklist"] as List?));
    return model;
  }

  Map<String, dynamic> toJSON() => {
        Constants.userId: userId,
        Constants.msg: msg,
        Constants.type: type,
        Constants.itemChatCounseling: itemChatCounseling,
        Constants.itemZoomCounseling: itemZoomCounseling,
        Constants.itemHarassmentTitle: itemHarassmentTitle,
        Constants.itemHarassmentContent: itemHarassmentContent,
        Constants.itemHarassmentButton1: itemHarassmentButton1,
        Constants.itemHarassmentButton2: itemHarassmentButton2,
        Constants.itemHarassmentPostback1: itemHarassmentPostback1,
        Constants.itemHarassmentPostback2: itemHarassmentPostback2,
        Constants.itemHarassmentConsultationTitle:
            itemHarassmentConsultationTitle,
        Constants.itemHarassmentConsultationContent:
            itemHarassmentConsultationContent,
        Constants.itemHarassmentTimeMsg2: itemHarassmentTimeMsg2,
        Constants.itemHarassmentTimeMsg1: itemHarassmentTimeMsg1,
        Constants.menuSelfCheckOnMindList: arrayToJSON(menuSelfCheckOnMindList),
        Constants.menuStretchingList: arrayToJSON(menuStretchingList),
        Constants.freqTitle: freqTitle,
        Constants.freqItem1: freqMsg_1,
        Constants.freqItem2: freqPostback_1,
        Constants.freqItem3: freqMsg_2,
        Constants.freqItem4: freqPostback_2,
        Constants.harassment_occurrence_title: harassment_occurrence_title,
        Constants.harassment_occurrence_breaking_time:
            harassment_occurrence_breaking_time,
        Constants.harassment_occurrence_after_work:
            harassment_occurrence_after_work,
        Constants.harassment_occurrence_holiday: harassment_occurrence_holiday,
        Constants.harassment_occurrence_others: harassment_occurrence_others,
        "postbacklist": arrayToJSON(postbackList),
        "postback": postback
      };

  List<Map<String, dynamic>> arrayToJSON(List<dynamic> data) {
    List<Map<String, dynamic>> allData = [];
    data.forEach((element) {
      allData.add(element.toJSON());
    });
    return allData;
  }

  List<SubMenuModel> getSubMenuList(List<dynamic> data) {
    List<SubMenuModel> allData = [];
    data.forEach((element) {
      allData.add(SubMenuModel.fromJSON(element));
    });
    return allData;
  }

  List<PostbackModel> getSubMenuListPostbackModel(List<dynamic>? data) {
    List<PostbackModel> allData = [];
    if (data != null) {
      data.forEach((element) {
        allData.add(PostbackModel.fromJSON(element));
      });
    }

    return allData;
  }
}
