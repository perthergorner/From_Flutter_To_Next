import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/model/account.dart';
import 'package:kirihare/utils/prefs.dart';

Dio dio = Dio();

Account? account;

class LoginAPI {
  static String hostUrl = "https://kirihare-web.jp";
//  static String hostUrl = "https://stg-web.cghosting.cloud";

  String employeeUrl = hostUrl + "/employee/webUser";
  String slackUrl = hostUrl + "/slack/applogin";
  String pushTokenFirebase = hostUrl + "/employee/addToken";
  String checkTwoPhaseCode = hostUrl + '/employee/checkTwoPhaseCode';
  String addPhoneNumber = hostUrl + "/employee/twoPhaseAuth";
  String helpUrl = hostUrl + '/web/manual';

  // final String baseUrl = 'http://localhost:3000/employee/webUser';
  Future<Account?> login(String mail, String password, String device,bool isSlackLogin) async {
    String clientId = '';
    Account? acc;
    String loginUrl = "";
    Map<String,dynamic> params = {};
    if (isSlackLogin) {
      loginUrl = slackUrl;
      params = {
        "m": mail,
        "p": password,
      };
    } else {
      loginUrl = employeeUrl;
      params = {
        Constants.MAIL: mail,
        Constants.PASSWORD: password,
        Constants.NEW_MENU: true,
      };
    }
    params[Constants.device] = device;
    final res = await dio.post(loginUrl, data: jsonEncode(params));
    if (res.data[Constants.userId] != null) {
      clientId = res.data[Constants.userId];
      acc = Account.fromJson(res.data);
      account = acc;
      Prefs.save(Constants.LAST_LOGIN_IS_SLASK, isSlackLogin);
    }
    return acc;
  }

  Future<bool?> pushTokenFireBase(String userId, String token) async {
    final params = {
      Constants.CODE: userId,
      Constants.TOKEN: token,
    };
    try {
      final res = await dio.post(pushTokenFirebase, data: jsonEncode(params));
      if (res.data["success"] != null) {
        return res.data["success"];
      }
    } on DioError catch (e) {
      return false;
    }
    return false;
  }

  Future<bool?> AddNumberPhone(String userId, String phone) async {
    final params = {
      Constants.CODE: userId,
      "phone": phone,
    };
    final res = await dio.post(addPhoneNumber, data: jsonEncode(params));
    if (res.data["success"] != null) {
      return res.data["success"];
    }
    return false;
  }

  Future<bool?> checkTwoCode(String userId, String code) async {
    final params = {
      Constants.CODE: userId,
      Constants.TCODE: code,
    };

    final res = await dio.post(checkTwoPhaseCode, data: jsonEncode(params));
    if (res.data["success"] != null) {
      return res.data["success"];
    }
    return false;
  }

  Future<String?> getHelpUrl(String userId) async {
    final params = {
      Constants.CODE: userId,
    };

    final res = await dio.get(helpUrl, data: jsonEncode(params));
    if (res.data != null) {
      return res.data;
    }
    return null;
  }
}
