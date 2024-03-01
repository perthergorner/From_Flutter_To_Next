import 'dart:convert';

import 'package:kirihare/model/rich_menu.dart';

class Account {
  bool? twoPhaseAuth;
  String? userId;
  String? phone;
  String? menuImageUrl;
  RichMenuModel? richMenuModel;

  Account({this.twoPhaseAuth, this.userId});

  Account.fromJson(Map<String, dynamic> json) {
    twoPhaseAuth = json['twoPhaseAuth'];
    userId = json['userId'];
    phone = json['phone'];
    menuImageUrl = json['menuImageUrl'];
    richMenuModel = RichMenuModel.fromJson(jsonDecode(json['menuJson']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['twoPhaseAuth'] = this.twoPhaseAuth;
    data['userId'] = this.userId;
    return data;
  }
}
