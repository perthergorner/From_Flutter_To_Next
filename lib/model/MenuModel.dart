import 'package:kirihare/common/APIConst.dart';
import 'package:kirihare/model/APIEndpoint.dart';

class MenuModel {
  String action = '';
  String icon = '';
  String title = '';
  String fontSize = '';
  String url = '';
  APIEndpoint apiEndpoint = APIEndpoint();

  MenuModel();

  factory MenuModel.fromJSON(Map<String, dynamic> res) {
    MenuModel model = new MenuModel();
    model.action = res[APIConst.action];
    model.icon = res[APIConst.icon];
    model.title = res[APIConst.title];
    model.apiEndpoint = APIEndpoint.fromJSON(res[APIConst.api_endpoint]);

    return model;
  }

  List<MenuModel> getMenuList(List<dynamic> res) {
    List<MenuModel> allData = [];
    res.forEach((element) {
      allData.add(new MenuModel.fromJSON(element as Map<String, dynamic>));
    });
    return allData;
  }
}