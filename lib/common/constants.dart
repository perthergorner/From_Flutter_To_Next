import 'package:flutter/cupertino.dart';
import 'package:kirihare/common/assets.dart';

class Constants {
  static const double rad = 0.0174533;
  // static const String WEB_SOCKET_URI = 'ws://3.112.165.187:2999/io/';
  static const String WEB_SOCKET_URI = 'wss://kirihare-api.jp/io/';
  //static const String WEB_SOCKET_URI = 'wss://stg-websocket.cghosting.cloud/io/';
  static const String RECEIVER = 'receiver';
  static const String SENDER = 'sender';
  static const String SELF_CHECK_ON_MIND = 'self_check_on_mind';
  static const String STRETCHING_MIND = 'stretching_mind';
  static const String MINUTES_PER_CONSULTANT = 'minutePerConsultant';
  static const String SELECT_RESERVATION_DATE = 'ご予約日を選択してください';
  static const String CHAT_COUNSELING_DATE_TIME = 'chatCounselingDateTime';
  static const String ZOOM_COUNSELING_DATE_TIME = 'zoomCounselingDateTime';
  static const String HARASSMENT_COUNSELING = 'harassmentCounseling';
  static const String HARASSMENT_COUNSELING_RESPONSE =
      'harassmentCounselingResponse';
  static const String HARASSMENT_TIME_MSG = 'harassmentTimeMsg';
  static const String CHAT_CAROUSE = 'chatCarouse';
  static const String CALENDAR = 'calendar';
  static const String PC = 'pc';
  static const String SMART_PHONE = 'smartPhone';
  static const String frequency = '頻度';

  static const List<AssetImage> MENU_ICONS = [
    Assets.IC_HOW_TO_USE,
    Assets.IC_SELF_CHECK_ON_MIND,
    Assets.IC_MENTAL_HEALTH_CONSULTATION,
    Assets.IC_INQUIRY,
    Assets.IC_STRETCHING_MIND,
    Assets.IC_USAGE_HISTORY
  ];

  static const List<AssetImage> SELF_CHECK_ON_MIND_ICONS = [
    Assets.IC_STRESS_CHECK,
    Assets.IC_FAMILY_RELATIONSHIP_CHECK,
    Assets.IC_LARGE_PERSON_ADHD_CHECK,
    Assets.IC_DEPRESSION_CHECK,
  ];

  static const List<AssetImage> STRETCHING_MIND_ICONS = [
    Assets.IC_SELF_CARE,
    Assets.IC_MINDFULNESS,
    Assets.IC_AUTOGENIC_TRAINING,
    Assets.IC_COLUMN_METHOD
  ];

  // broadcast constants
  static const String PLAY_BEEP = 'play_beep';
  static const String SEND_MENU_MSG = 'send_menu_message';
  static const String SEND_MSG = 'send_message';
  static const String WEB_SOCKET_CONNECTED = 'webSocketConnected';
  static const String WEB_SOCKET_MAIN_MENU = 'webSocketMainMenu';
  static const String CHAT = 'chat';

  static const String SUGGESTION_EVENT = 'suggestion';
  static const String CAROUSE = 'carouse';

  static const String WEB_SOCKET_SELF_CHECK_ON_MIND = 'webSocketSubMenu';
  static const String WEB_SOCKET_STRETCHING_MINID = 'webSocketStretchingMind';
  static const String WEB_SOCKET_LINE_HEALTH_ROOM = 'webSocketLineHealthRoom';
  static const String WEB_SOCKET_CHAT_COUNSELING = 'webSocketCounseling';
  static const String WEB_SOCKET_ZOOM_COUNSELING = 'webSocketZoomCounseling';
  static const String CHAT_COUNSELING = 'chatCounseling';
  static const String ZOOM_COUNSELING = 'zoomCounseling';
  static const String CHAT_COUNSELING_CALENDAR = 'chatCounselingCalendar';
  static const String ZOOM_COUNSELING_CALENDAR = 'zoomCounselingCalendar';
  static const String CHAT_COUNSELING_RESERVE_TIME =
      'chatCounselingReserveTime';
  static const String ZOOM_COUNSELING_RESERVE_TIME =
      'zoomCounselingReserveTime';
  static const String HARASSMENT_COUNSELING_INQUIRY =
      'harassmentCounselingInquiry';
  static const String HARASSMENT_POSTBACK = 'harassmentPostback';
  static const String HARASSMENT_TIME = 'harassmentTime';
  static const String SELECT_HARASSMENT_COUNSELING_TIME =
      'selectHarssmentCounselingTime';
  static const String FREQUENCY_MSG = 'frequency_msg';
  static const String HARASSMENT_OCCURRENCE_TIME_MSG =
      'harassmentOccurrenceTimeMsg';
  static const String FREQ_DURING_WORKING_HOURS = 'freqDuringWorkingHours';
  static const String FREQ_DURING_WORKING_OUT = 'freqDuringWorkingOut';
  static const String FREQ_DURING_WORKING_HOURS_OUT =
      'freqDuringWorkingHoursOut';
  static const String WHICH_TIME_IN_HARASSMENT_OCCURRENCE =
      'whichTimeInHarassmentOccurrence';

  // API constants
  static const String CODE = 'code';
  static const String TCODE = 'tcode';
  static const String TOKEN = 'token';
  static const String MAIL = 'mail';
  static const String PASSWORD = 'password';
  static const String PLAN_ID = 'planId';
  static const String NEW_MENU = 'newMenu';
  static const String LAST_LOGIN_IS_SLASK = "last_login_is_slack";
  static const String USER_CHECK = 'USER_CHECK';
  static const String PHONE_NUMBER = 'number_phone';
  static const String device = 'device';
  static const String RESULT = 'result';
  static const String SOCKET_MSG_GET_USAGE_MENU = '利用メニューの取得';
  static const String YOU_ARE_CONNECTED = 'You are connected!';
  static const String TYPE_PING= 'ping';
  static const String type = 'type';
  static const String DATE_TIME = 'datetime';
  static const String MAIN_MENU = 'mainmenu';
  static const String SUB_MENU = 'submenu';
  static const String VALUE = 'value';
  static const String IMG_URL = 'imgUrl';
  static const String MESSAGE = 'message';
  static const String LIST = 'list';
  static const String LABLE = 'label';
  static const String POSTBACK = 'postback';
  static const String TITLE = 'title';
  static const String POSTBACK_MESSAGE = 'postbackMessage';
  static const String DISPLAY_TYPE = 'displayType';

  // Firebase API Const
  static const String userId = 'userId';
  static const String twoPhaseAuth = 'twoPhaseAuth';
  static const String msg = 'msg';
  static const String itemChatCounseling = 'itemChatCounseling';
  static const String itemZoomCounseling = 'itemZoomCounseling';
  static const String itemHarassmentTitle = 'itemHarassmentTitle';
  static const String itemHarassmentContent = 'itemHarassmentContent';
  static const String itemHarassmentButton1 = 'itemHarassmentButton1';
  static const String itemHarassmentButton2 = 'itemHarassmentButton2';
  static const String itemHarassmentPostback1 = 'itemHarassmentPostback1';
  static const String itemHarassmentPostback2 = 'itemHarassmentPostback2';
  static const String itemHarassmentConsultationTitle =
      'itemHarassmentConsultationTitle';
  static const String itemHarassmentConsultationContent =
      'itemHarassmentConsultationContent';
  static const String itemHarassmentTimeMsg1 = 'itemHarassmentTimeMsg1';
  static const String itemHarassmentTimeMsg2 = 'itemHarassmentTimeMsg2';
  static const String value = 'value';
  static const String imgUrl = 'imgUrl';
  static const String menuSelfCheckOnMindList = 'menuSelfCheckOnMindList';
  static const String menuStretchingList = 'menuStretchingList';
  static const String freqTitle = 'freqTitle';
  static const String freqItem1 = 'freqItem1';
  static const String freqItem2 = 'freqItem2';
  static const String freqItem3 = 'freqItem3';
  static const String freqItem4 = 'freqItem4';
  static const String rowIndex = 'rowIndex';

  static const String harassment_occurrence_title =
      'harassment_occurrence_title';
  static const String harassment_occurrence_breaking_time =
      'harassment_occurrence_breaking_time';
  static const String harassment_occurrence_after_work =
      'harassment_occurrence_after_work';
  static const String harassment_occurrence_holiday =
      'harassment_occurrence_holiday';
  static const String harassment_occurrence_others =
      'harassment_occurrence_others';
}
