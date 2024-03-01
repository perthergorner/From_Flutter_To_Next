import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:kirihare/common/api.dart';
import 'package:kirihare/model/msg_model.dart';
import 'package:dio/dio.dart';

HistoryAPI historyAPI = new HistoryAPI();

class HistoryAPI {
  Dio dio = Dio();

  // final String baseUrl = 'https://kirihare-web.jp/employee/webUser';
  final String getHistory = LoginAPI.hostUrl +
      '/BB99AABCSESB73rfjpADc_A53hHAyN9ihb34FTVdD7kcjuC7nHLhkJiCQE3asNMe6s';
  final String addHistory = LoginAPI.hostUrl +
      '/BB99AABCSEwwSB73rfjpADc_33A53hHAyN9ihb34FTVdD7kcjuC7nHLhkJiCQE3asNMe6s';

  static const String TB_CHAT_HISTORY = 'ChatHistory';

  Future<List<MsgModel>?> getChatHistory(String userId) async {
    debugPrint("start getChatHistory");
    List<MsgModel> allData = [];

    final params = {"webUserId": userId};
    try {
      final response = await dio.post(getHistory, data: jsonEncode(params));
      List<dynamic> test = response.data["list"];
      test.forEach((element) {
        MsgModel model = MsgModel().fromJSON(element);
        allData.add(model);
      });
      return allData;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  var notSendList = [
    "利用メニューの取得",
    "ご利用方法の説明",
    "心のセルフチェック",
    "心のストレッチ",
    "オンライン保健室では",
    "オンライン保健室",
    "ハラスメント相談",
    "コード取得",
    "カウンセリング予約"
  ];

  Future<bool> addMsg(MsgModel model) async {

    if (notSendList.contains(model.msg)) {
      return true;
    }
    if (model.itemHarassmentButton1 == "[有人]ハラスメント相談") {
      return true;
    }
    if (model.itemHarassmentButton1 == "電話カウンセリング") {
      return true;
    }
    if (model.menuSelfCheckOnMindList.isNotEmpty) {
      return true;
    }

    if (model.menuStretchingList.isNotEmpty) {
      return true;
    }

    final params = {"webUserId": model.userId, "json": model.toJSON()};


    final data = jsonEncode(params);
    final response = await dio.post(addHistory, data: data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
