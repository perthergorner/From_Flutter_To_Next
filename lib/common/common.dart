import 'package:kirihare/common/websocket_api.dart';
import 'package:kirihare/model/MenuModel.dart';

class Common {
  static WebSocketAPI? webSocketAPI;
  static String chatCounseling = '';
  static String zoomCounseling = '';
  static String chatCounselingTime = '';
  static String zoomCounselingTime = '';
  static String harassmentPostback1 = '';
  static String harassmentPostback2 = '';
  static String harassmentTime = '';
  static String frequencyTime = '';
  static String menu0 = '';
  static String menuSelect = '';

  static String menu1 = '心のセルフチェック';
  static String menu2 = 'オンライン保健室';
  static String menu3 = 'ハラスメント相談';
  static String menu4 = '心のストレッチ';
  static String menu5 = '';

  static String device = '';
  static String userId = '';
  static String userName = '';
  static String userPhone = '';
  static String frequency = '';
  static String freqDuringWorkHoursOut = '';
  static String freqPostback_1 = '';
  static List<MenuModel> menuList = [];
  static List<String> menuMain = [];
}

extension ListFromMap<Key, Element> on Map<Key, Element> {
  List<T> toList<T>(T Function(MapEntry<Key, Element> entry) getElement) =>
      entries.map(getElement).toList();
}
