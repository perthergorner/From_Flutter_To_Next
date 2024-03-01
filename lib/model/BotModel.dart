import 'package:kirihare/common/APIConst.dart';
import 'package:kirihare/common/api.dart';
import 'package:kirihare/model/APIEndpoint.dart';
import 'package:kirihare/model/MenuModel.dart';

class BotModel {
  String senderId = '';
  String msg = '';
  String device = '';
  String type = '';
  Bot bot = new Bot();


  BotModel();

  factory BotModel.fromJSON(Map<String, dynamic> res) {
    BotModel model = new BotModel();
    model.senderId = res[APIConst.senderId];
    model.msg = res[APIConst.msg];
    model.device = res[APIConst.device];
    model.type = res[APIConst.type];
    model.bot = Bot.fromJSON(res[APIConst.bot]);

    return model;
  }
}

class Bot {
  String type = '';
  List<MenuModel> menu = [];
  List<MsgModel> msg = [];
  
  Bot();

  factory Bot.fromJSON(Map<String, dynamic> res) {
    Bot model = new Bot();
    model.type = res[APIConst.type];
    model.menu.addAll(MenuModel().getMenuList(res[APIConst.menu]));
    model.msg.addAll(MsgModel().getList(res[APIConst.msg]));

    return model;
  }
}

class MsgModel {
  String title = '';
  String title_fontsize = '';
  String content = '';
  String content_fontsize = '';
  String devide_line = '';
  List<ButtonModel> buttons = [];

  MsgModel();

  factory MsgModel.fromJSON(Map<String, dynamic> res) {
    MsgModel model = new MsgModel();
    model.title = res[APIConst.title];
    model.title_fontsize = res[APIConst.title_fontsize];
    model.content = res[APIConst.content];
    model.content_fontsize = res[APIConst.content_fontsize];
    model.buttons.addAll(ButtonModel().getList(res[APIConst.button]));
    return model;
  }

  List<MsgModel> getList(List<dynamic> res) {
    List<MsgModel> allData = [];
    res.forEach((element) {
      allData.add(MsgModel.fromJSON(element as Map<String, dynamic>));
    });
    return allData;
  }
}

class ButtonModel {
  String action = '';
  String title = '';
  String fontsize = '';
  APIEndpoint apiEndpoint = new APIEndpoint();
  List<Params> params = [];

  ButtonModel();

  factory ButtonModel.fromJSON(Map<String, dynamic> res) {
    ButtonModel model = new ButtonModel();
    model.action = res[APIConst.action];
    model.title = res[APIConst.title];
    model.fontsize = res[APIConst.fontSize];
    model.apiEndpoint = APIEndpoint.fromJSON(res[APIConst.api_endpoint]);
    model.params = Params().getList(res[APIConst.params]);

    return model;
  }

  List<ButtonModel> getList(List<dynamic> res) {
    List<ButtonModel> allData = [];
    res.forEach((element) {
      allData.add(ButtonModel.fromJSON(element as Map<String, dynamic>));
    });
    return allData;
  }
}

class Params {
  String key = '';
  String value = '';

  Params();

  factory Params.fromJSON(Map<String, dynamic> res) {
    Params model = new Params();
    model.key = res[APIConst.key];
    model.value = res[APIConst.value];
    return model;
  }

  List<Params> getList(List<dynamic> res) {
    List<Params> allData = [];
    res.forEach((element) {
      allData.add(Params.fromJSON(element as Map<String, dynamic>));
    });

    return allData;
  }
}