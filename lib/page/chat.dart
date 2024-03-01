import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:kirihare/model/rich_menu.dart';
import 'package:kirihare/page/chat_components/current_main_menu.dart';
import 'package:kirihare/page/chat_components/custom_menu_bar/custom_menu_bar.dart';
import 'package:kirihare/page/chat_components/help_button.dart';
import 'package:kirihare/page/chat_components/lock_open_button.dart';
import 'package:kirihare/page/chat_components/login_button.dart';
import 'package:kirihare/page/chat_components/responsive/for_pc/custom_menu_for_pc.dart';
import 'package:kirihare/page/chat_components/responsive/for_pc/custom_message_box_for_pc.dart';
import 'package:kirihare/page/chat_components/index_elements/index_elements.dart';
import 'package:kirihare/page/chat_components/message_list.dart';
import 'package:kirihare/page/chat_components/particulars.dart';
import 'package:kirihare/page/chat_components/responsive/for_pc/search_field_for_pc.dart';
import 'package:kirihare/page/chat_components/responsive/for_phone/custom_menu_for_phone.dart';
import 'package:kirihare/page/chat_components/responsive/for_phone/custom_message_box_for_phone.dart';
import 'package:kirihare/page/chat_components/responsive/for_phone/search_field_for_phone.dart';
import 'package:kirihare/page/chat_components/search_button.dart';
import 'package:kirihare/page/chat_components/title_text.dart';
import 'package:universal_html/html.dart' as html;
import 'package:collection/collection.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:kirihare/common/api.dart';
import 'package:kirihare/model/health_room_model.dart';
import 'package:kirihare/utils/prefs.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:soundpool/soundpool.dart';
import 'package:kirihare/adapter/msg_adapter.dart';
import 'package:kirihare/common/FirebaseAPI.dart';
import 'package:kirihare/common/assets.dart';
import 'package:kirihare/common/common.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/model/chat_counseling_model.dart';
import 'package:kirihare/model/main_menu_model.dart';
import 'package:kirihare/model/msg_model.dart';
import 'package:kirihare/model/sub_menu_model.dart';
import 'package:kirihare/model/zoom_counseling_model.dart';
import 'package:kirihare/utils/utils.dart';

import '../model/Browser.dart';
import '../model/KirihareAction.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  Soundpool? soundPool;

  bool loading = false;
  final TextEditingController edtMsg = new TextEditingController();
  final ItemScrollController scrollController = new ItemScrollController();

  bool showMenu = false, showMenuBar = false;
  List<MsgModel> allMsg = [];
  List<MsgModel> searchResult = [];

  List<MainMenuModel> mainMenuList = [];
  List<SubMenuModel> menuSelfCheckOnMindList = [];
  List<SubMenuModel> menuStretchingMindList = [];
  bool isSearch = false;
  MainMenuModel? currentMainMenuModel;
  Areas? currentRichMenuArea;

  late Future<int> soundId;
  int? alarmSoundStreamId;
  List<MsgModel> searchIndex = [];
  int indexSelect = 1;
  String textSearch = '';
  String textSearch_tg = '';

  ItemScrollController _scrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  FocusNode searchFocusNode = FocusNode();

  bool isCheckCall = false;

  Timer? webSocketTimer;

// endEventext
  void addEvent(List<KirihareAction> dlist) {
    for (var val in dlist) {
      switch (val.type) {
        case "url": // openUrl
          Browser.openWebBrowser(val.value);
          break;
        case "text":
          FBroadcast.instance().register(
              Constants.FREQ_DURING_WORKING_HOURS_OUT, (value, callback) {
            Common.webSocketAPI?.sendMsg(Constants.MESSAGE, val.value);
            sendMsg(val.value, Constants.SENDER);
          });
      }
    }
  }

  // getToken firebase
  void uploadToken() async {
    if (Common.userId != 'skip') {
      String? token = await FirebaseMessaging.instance.getToken();
      LoginAPI()
          .pushTokenFireBase(Common.userId, token ?? "")
          .then((value) => {print(" $value")});
    }
  }

  void hideCapcha() {
    if (kIsWeb) {
      final el =
          html.window.document.getElementById('__ff-recaptcha-container');
      if (el != null) {
        el.style.visibility = 'hidden';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    createWebSocketTimer();

    if (!Common.userId.contains("SKIPCODE")) {
      getChatHistory();
      uploadToken();
    }
    hideCapcha();
    getMainMenu();
    showProgress();
    showMenu = true;
    showMenuBar = true;

    // メインメニュー
    //getMenu
    if (!isCheckCall) {
      FBroadcast.instance().unregister(this);
      isCheckCall = true;

      FBroadcast.instance().register(
        Constants.WEB_SOCKET_MAIN_MENU,
        (value, callback) {
          closeProgress();
          List<MainMenuModel> mMeluList = [];
          dynamic v = jsonDecode(value["value"]);
          v.forEach((k, v) {
            MainMenuModel m = MainMenuModel.fromJSON(v);
            if (m.value.isNotEmpty) mMeluList.add(m);
          });
          setState(() {
            mainMenuList = mMeluList;
          });
        },
        context: this,
      );



      FBroadcast.instance().register(
        Constants.WHICH_TIME_IN_HARASSMENT_OCCURRENCE,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final temp = v as Map<String, dynamic>;
          MsgModel model = new MsgModel();
          model.harassment_occurrence_title = temp[Constants.TITLE];
          model.harassment_occurrence_breaking_time =
              temp[Constants.LIST][0][Constants.LABLE];
          model.harassment_occurrence_after_work =
              temp[Constants.LIST][1][Constants.LABLE];
          model.harassment_occurrence_holiday =
              temp[Constants.LIST][2][Constants.LABLE];
          model.harassment_occurrence_others =
              temp[Constants.LIST][3][Constants.LABLE];
          model.type = Constants.HARASSMENT_OCCURRENCE_TIME_MSG;
          addMsg(model);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.FREQ_DURING_WORKING_HOURS_OUT,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final temp = v as MsgModel;
          MsgModel model = new MsgModel();
          model.msg = temp.freqPostback_2;
          model.type = Constants.SENDER;

          addMsg(model);

          Common.freqDuringWorkHoursOut = temp.freqPostback_2;
          Common.webSocketAPI
              ?.sendFreqDuringWorkingHoursOut(temp.freqPostback_2);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.FREQ_DURING_WORKING_HOURS,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final MsgModel temp = v as MsgModel;

          MsgModel model = new MsgModel();
          model.msg = temp.freqMsg_1;
          model.type = Constants.SENDER;

          addMsg(model);
          Common.freqPostback_1 = temp.freqPostback_1;
          Common.webSocketAPI
              ?.sendFrequencyMsg(Common.device, temp.freqPostback_1);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.FREQ_DURING_WORKING_OUT,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          // final MsgModel = value as MsgModel;
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.FREQUENCY_MSG,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final String freqTitle = v[Constants.TITLE];

          final temp1 = v[Constants.LIST] as List;
          final String freqItem1 = temp1[0][Constants.LABLE];
          final String freqItem2 = temp1[0][Constants.POSTBACK];
          final String freqItem3 = temp1[1][Constants.LABLE];
          final String freqItem4 = temp1[1][Constants.POSTBACK];

          MsgModel msg = new MsgModel();
          msg.type = Constants.FREQUENCY_MSG;
          msg.freqTitle = freqTitle;
          msg.freqMsg_1 = freqItem1;
          msg.freqPostback_1 = freqItem2;
          msg.freqMsg_2 = freqItem3;
          msg.freqPostback_2 = freqItem4;

          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.HARASSMENT_TIME,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final temp = v["list"] as List;
          final msg1 = temp[0][Constants.VALUE];
          MsgModel msg = new MsgModel();
          msg.itemHarassmentTimeMsg1 = msg1;
          msg.type = Constants.HARASSMENT_TIME_MSG;

          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.SELECT_HARASSMENT_COUNSELING_TIME,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);

          MsgModel model = v;
          showHarassmentTimeCalendar(model.itemHarassmentConsultationContent);
        },
        context: this,
      );
      //set timeView
      FBroadcast.instance().register(
        Constants.HARASSMENT_POSTBACK,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          MsgModel msg = new MsgModel();
          msg.type = Constants.HARASSMENT_COUNSELING_RESPONSE;
          msg.itemHarassmentConsultationTitle = v[Constants.TITLE];
          msg.itemHarassmentConsultationContent = v[Constants.POSTBACK_MESSAGE];

          final responseType = v[Constants.type];
          if (responseType == Constants.CALENDAR) {
            Future.delayed(Duration(milliseconds: 700), () {
              showHarassmentTimeCalendar(v[Constants.POSTBACK_MESSAGE]);
            });
          }

          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.HARASSMENT_COUNSELING_INQUIRY,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final data = v[Constants.LIST];
          final title = data[1][Constants.TITLE];
          final content = data[0][Constants.VALUE];

          final btnTitle1 = data[1][Constants.LIST][0][Constants.LABLE];
          final postback1 = data[1][Constants.LIST][0][Constants.POSTBACK];

          final btnTitle2 = data[1][Constants.LIST][1][Constants.LABLE];
          final postback2 = data[1][Constants.LIST][1][Constants.POSTBACK];

          MsgModel msg = new MsgModel();
          msg.type = Constants.HARASSMENT_COUNSELING;
          msg.itemHarassmentTitle = title;
          msg.itemHarassmentContent = content;
          msg.itemHarassmentButton1 = btnTitle1;
          msg.itemHarassmentButton2 = btnTitle2;
          msg.itemHarassmentPostback1 = postback1;
          msg.itemHarassmentPostback2 = postback2;
          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.CHAT_COUNSELING_RESERVE_TIME,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final data = v[Constants.LIST];
          final receivedMsg = data[0][Constants.VALUE];

          MsgModel msg = new MsgModel();
          msg.type = Constants.RECEIVER;
          msg.msg = receivedMsg;
          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.ZOOM_COUNSELING_RESERVE_TIME,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          final data = v['list'];
          final receivedMsg = data[0]['value'];

          MsgModel msg = new MsgModel();
          msg.type = Constants.RECEIVER;
          msg.msg = receivedMsg;
          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.CHAT_COUNSELING_CALENDAR,
        (value, callback) {
          final postback = value as String;
          showChatCounselingCalendar(postback);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.ZOOM_COUNSELING_CALENDAR,
        (value, callback) {
          final postback = value as String;
          showZoomCounselingCalendar(postback);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.ZOOM_COUNSELING,
        (value, callback) {
          final String temp = value as String;
          MsgModel msg = new MsgModel();
          msg.msg = temp;
          msg.type = Constants.RECEIVER;

          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.WEB_SOCKET_ZOOM_COUNSELING,
        (value, callback) {
          ZoomCounselingModel model = new ZoomCounselingModel.fromJSON(value);

          MsgModel msg = new MsgModel();
          msg.type = Constants.ZOOM_COUNSELING_DATE_TIME;
          msg.msg = model.postbackMessage;

          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.CHAT_COUNSELING,
        (value, callback) {
          final String temp = value as String;
          setState(() {
            MsgModel msg = new MsgModel();
            msg.msg = temp;
            msg.type = Constants.RECEIVER;

            addMsg(msg);
          });
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.WEB_SOCKET_CHAT_COUNSELING,
        (value, callback) {
          ChatCounselingModel model = new ChatCounselingModel.fromJSON(
              jsonDecode(value['value'].toString()));
          MsgModel msg = new MsgModel();
          msg.type = Constants.CHAT_COUNSELING_DATE_TIME;
          msg.msg = model.postbackMessage; //"チャットカウンセリング";
          msg.postback = model.postbackMessage;
          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.CHAT,
        (value, callback) {
          String v = value["message"];
          addExplainMsg(v);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.WEB_SOCKET_LINE_HEALTH_ROOM,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          var temp = v[Constants.LIST] as List;
          HealthRoomModel model = new HealthRoomModel.fromJSON(temp);
          MsgModel msg = new MsgModel();
          msg.msg = model.value;
          msg.type = Constants.RECEIVER;
          addMsg(msg);
          MsgModel msg1 = new MsgModel();
          msg1.type = Constants.MINUTES_PER_CONSULTANT;
          msg1.msg = model.title;
          msg1.postbackList = model.postbackList;
          msg1.itemChatCounseling = model.postbackList[0].postback;
          msg1.itemZoomCounseling = model.postbackList[1].postback;
          msg1.itemHarassmentButton1 = model.postbackList[2].postback;

          addMsg(msg1);
        },
        context: this,
      );

      // mini list
      FBroadcast.instance().register(
        Constants.WEB_SOCKET_SELF_CHECK_ON_MIND,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          menuSelfCheckOnMindList.clear();
          int indexNotMap = 0;
          MsgModel msg = new MsgModel();
          msg.msg = '';
          msg.type = Constants.SELF_CHECK_ON_MIND;

          v.forEach((k, value) {
            if (k == "explainText") {
              addExplainMsg(value);
            }
            if (!(value is Map)) {
              indexNotMap++;
            } else {
              menuSelfCheckOnMindList.add(SubMenuModel.fromJSON(value));
            }
            if (menuSelfCheckOnMindList.length == v.length - indexNotMap) {
              msg.menuSelfCheckOnMindList.addAll(menuSelfCheckOnMindList);
              //allMsg.removeAt(0);
              addMsg(msg);
            }
          });
        },
        context: this,
      );
      //minilist
      FBroadcast.instance().register(
        Constants.WEB_SOCKET_STRETCHING_MINID,
        (value, callback) {
          dynamic v = jsonDecode(value["value"]);
          int indexNotMap = 0;
          menuStretchingMindList.clear();

          MsgModel msg = new MsgModel();
          msg.msg = '';
          msg.type = Constants.STRETCHING_MIND;
          v.forEach((k, value) {
            if (k == "explainText") {
              addExplainMsg(value);
            }
            if (!(value is Map)) {
              indexNotMap++;
            } else {
              menuStretchingMindList.add(SubMenuModel.fromJSON(value));
            }
            if (menuStretchingMindList.length == v.length - indexNotMap) {
              msg.menuStretchingList.addAll(menuStretchingMindList);
              //allMsg.removeAt(0);
              addMsg(msg);
            }
          });
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.SEND_MENU_MSG,
        (value, callback) {
          print("Registering SEND_MENU_MSG broadcast listener...");
          int menuIndex = value as int;
          if (value is int) {
            int menuIndex = value;
            print("Received menuIndex in SEND_MENU_MSG: $menuIndex");
          } else {
            print("Error: Unexpected value type for SEND_MENU_MSG: $value");
            return;
          }
          final data =
              MediaQueryData.fromWindow(WidgetsBinding.instance.window);
          print("Device shortest side: ${data.size.shortestSide}");

          if (data.size.shortestSide < 550) {
            print("Executing for device with shortest side < 550");
            switch (currentRichMenuArea!.action.type) {
              case "url":
                print("Action type: url");
                print(currentRichMenuArea!.action.uri);
                if (currentRichMenuArea!.action.uri != null) {
                  Browser.openWebBrowser(currentRichMenuArea!.action.uri!);
                }
                break;
              case "message":
                Common.webSocketAPI?.sendMsg(
                    Constants.MESSAGE, currentRichMenuArea!.action.text);
                Common.menuSelect = currentRichMenuArea!.action.text;
                sendMsg(currentRichMenuArea!.action.text, Constants.SENDER);
            }
          } else {
            switch (mainMenuList[menuIndex].type) {
              case "url":
                Browser.openWebBrowser(mainMenuList[menuIndex].value);
                break;
              case "text":
                Common.webSocketAPI
                    ?.sendMsg(Constants.MESSAGE, mainMenuList[menuIndex].value);
                Common.menuSelect = mainMenuList[menuIndex].value;
                sendMsg(mainMenuList[menuIndex].value, Constants.SENDER);
            }
          }
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.CAROUSE,
        (value, callback) {
          print("CAROUSE: ${value}");
          MsgModel msg = new MsgModel();
          msg.type = Constants.CHAT_CAROUSE;
          msg.msg = value;
          addMsg(msg);
        },
        context: this,
      );

      FBroadcast.instance().register(
        Constants.SUGGESTION_EVENT,
            (value, callback) {
            print("FBroadcast.instance().register SUGGESTION_EVENT");
            MsgModel msgModel = MsgModel();
            msgModel.type = Constants.SUGGESTION_EVENT;
            msgModel.msg = value;
            addMsg(msgModel);
        },
        context: this,
      );



      FBroadcast.instance().register(
        Constants.SEND_MSG,
        (value, callback) {
          sendMessageToWebsocket(value);
        },
        context: this,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => {isCheckCall = false});

    soundPool = Soundpool(streamType: StreamType.notification);
    soundId = _loadSound();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    webSocketTimer?.cancel();

    /// remove all receivers from the environment
    FBroadcast.instance().unregister(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getChatHistory();
      createWebSocketTimer();
    } else if (state == AppLifecycleState.paused) {
      // Pause the timer when the app is paused
      webSocketTimer?.cancel();
    }
  }

  void createWebSocketTimer() {
    webSocketTimer?.cancel();
    webSocketTimer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      Common.webSocketAPI?.checkConnection();
    });
  }

  void onTapNextSearch(int i) {
    int selectIndex = 0;
    if (searchIndex.length > 0) {
      if (i == 0) {
        selectIndex = searchIndex.first.rowIndex;
        indexSelect = 1;
        setState(() {});
        scrollViewList(selectIndex);
      } else {
        indexSelect = indexSelect + i;
        if (searchIndex.length < indexSelect) {
          indexSelect = 1;
        } else if (indexSelect <= 0) {
          indexSelect = searchIndex.length;
        }
        selectIndex = searchIndex[indexSelect - 1].rowIndex;
        setState(() {});
        scrollViewList(selectIndex);
      }
    }
  }

  void scrollViewList(int i) {
    _scrollController.scrollTo(index: i, duration: Duration(milliseconds: 500));
  }

  void sendMenuMsg(MainMenuModel model) {
    Common.webSocketAPI?.sendMsg(Constants.MESSAGE, model.value);
    sendMsg(model.value, Constants.SENDER);
  }

  // lấy về lịch sử chat
  void getChatHistory() {
    showProgress();
    historyAPI.getChatHistory(Common.userId).then((value) {
      closeProgress();
      if (value == null) return;
      allMsg.clear();
      searchResult.clear();

      allMsg.addAll(value.reversed);
      setState(() {
        searchResult.addAll(allMsg);
      });
    });
  }

  void showHarassmentTimeCalendar(String postback) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
        onChanged: (date) {
      //print('change $date');
    }, onConfirm: (date) {
      Common.harassmentTime = postback;
      Common.webSocketAPI
          ?.sendHarassmentTime(Utils.getFormattedDate(date), postback);
    }, currentTime: DateTime.now(), locale: LocaleType.jp);
  }

  void showChatCounselingCalendar(String postback) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
        onChanged: (date) {
      //print('change $date');
    }, onConfirm: (date) {
      Common.chatCounselingTime = postback;
      Common.webSocketAPI
          ?.sendCounselingTime(Utils.getFormattedDate(date), postback);
    }, currentTime: DateTime.now(), locale: LocaleType.jp);
  }

  void showZoomCounselingCalendar(String postback) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
        onChanged: (date) {
      //print('change $date');
    }, onConfirm: (date) {
      //print('confirm $date');
      Common.zoomCounselingTime = postback;
      Common.webSocketAPI
          ?.sendCounselingTime(Utils.getFormattedDate(date), postback);
    }, currentTime: DateTime.now(), locale: LocaleType.jp);
  }

  // lấy ra main menu
  void getMainMenu() async {
    closeProgress();

    Common.webSocketAPI
        ?.sendMsg(Constants.MESSAGE, Constants.SOCKET_MSG_GET_USAGE_MENU);
  }

  void loadChatMsg() {
    for (int i = 0; i < 10; i++) {
      MsgModel model = new MsgModel();
      model.msg = generateRandomString(80);
      if (i % 2 == 0) {
        model.type = Constants.RECEIVER;
      } else {
        model.type = Constants.SENDER;
      }
      allMsg.add(model);
    }

    setState(() {
      allMsg.reversed;
    });
  }

  void sendMsg(String msg, String messageType) {
    MsgModel model = new MsgModel();
    model.msg = msg;
    model.type = messageType;

    addMsg(model);
  }

  String generateRandomString(int len) {
    var r = Random();
    String randomString =
        String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
    return randomString;
  }

  void addExplainMsg(String explainText) {
    MsgModel explainMsg = new MsgModel();
    explainMsg.msg = explainText;
    explainMsg.type = Constants.RECEIVER;
    addMsgNoHistory(explainMsg);
  }

  void addMsgNoHistory(MsgModel model) {
    if (checkScroll && searchResult.length != 0) {
      checkScroll = false;
    }
    allMsg.insert(0, model);
    searchResult.insert(0, model);
    model.userId = Common.userId;
    //clear search
    isSearch = false;
    searchIndex.clear();
    setState(() {});
    if (!checkScroll) {
      scrollViewList(0);
    }
  }

  void addMsg(MsgModel model) {
    if (checkScroll && searchResult.length != 0) {
      checkScroll = false;
    }
    allMsg.insert(0, model);
    searchResult.insert(0, model);

    model.userId = Common.userId;
    historyAPI.addMsg(model);
    //clear search
    isSearch = false;
    searchIndex.clear();
    setState(() {});
    if (!checkScroll) {
      scrollViewList(0);
    }
  }

  bool checkScroll = true;
  String phone = '';

  void getPhoneRestore() async {
    phone = await Prefs.restore(Constants.PHONE_NUMBER);
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    Widget child = data.size.shortestSide < 550
        ? _buildWidgetForPhone(context)
        : _buildWidgetForPC(context);
    return new Scaffold(
      body: ModalProgressHUD(child: child, inAsyncCall: loading),
    );
  }

  Widget _buildMsgItem(int index) {
    searchResult[index].selectFlag = false;
    searchResult[index].colorSelect = null;
    searchResult[index].textSearch = null;
    if (searchIndex.length > 0) {
      MsgModel? s = searchIndex.firstWhereOrNull((element) {
        return element.rowIndex == index;
      });

      if (s != null) {
        searchResult[index].colorSelect = Colors.amber;
        searchResult[index].textSearch = textSearch;
      }
      if (index == searchIndex[indexSelect - 1].rowIndex) {
        searchResult[index].selectFlag = true;
      }
    }

    return MessageAdapter().msgItem(context, searchResult[index]);
  }

  Widget _buildWidgetForPhone(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: false,
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  titleSpacing: 0,
                  backgroundColor: Colors.green,
                  title: Stack(
                    children: [
                      TitleText(isSearch: isSearch),
                      SearchFieldForPhone(
                          isSearch: isSearch,
                          onClearButtonPressed: onClearButtonPressed,
                          searchFocusNode: searchFocusNode,
                          onSubmitted: onSubmitted,
                          onChanged: (text) => onChanged(text))
                    ],
                  ),
                  actions: [
                    SearchButton(
                        isSearch: isSearch,
                        onSearchButtonPressed: onSearchButtonPressed),
                    if (!Common.userId.contains("SKIPCODE"))
                      const LockOpenButton()
                    else
                      const LoginButton(),
                    const HelpButton(),
                  ],
                ),
                body: Column(
                  children: [
                    // message list
                    MessageList(
                        itemPositionsListener: itemPositionsListener,
                        itemScrollController: _scrollController,
                        itemCount: searchResult.length,
                        itemBuilder: (_, index) => _buildMsgItem(index)),
                    IndexElements(
                      indexSelect: indexSelect,
                      searchIndex: searchIndex,
                      onUpArrowTap: () => onTapNextSearch(1),
                      onDownArrowTap: () => onTapNextSearch(-1),
                    ),
                    // menu
                    CustomMenuForPhone(
                      showMenu: showMenu,
                      richMenuModel: account?.richMenuModel,
                      callBack: onMainMenuPressed,
                    ),
                    Stack(
                      children: [
                        // message box
                        CustomMessageBoxForPhone(
                            onMenuPressed: onMenuPressed,
                            edtMsg: edtMsg,
                            onSendPressed: onSendPressed),
                        // menu bar
                        CustomMenuBar(
                            showMenuBar: showMenuBar,
                            showMenu: showMenu,
                            onKeyBoardPressed: onKeyBoardPressed,
                            toggleShowMenu: toggleShowMenu)
                      ],
                    )
                  ],
                ))));
  }

  Widget _buildWidgetForPC(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return SafeArea(
        bottom: true,
        top: false,
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                body: Row(
              children: [
                // menu
                CustomMenuForPC(
                  mainMenuList: mainMenuList,
                  callBack: onMainMenuPressed,
                ),
                const Spacer(),
                // 横幅の80%
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchFieldForPC(
                        searchFocusNode: searchFocusNode,
                        onSubmitted: onSubmitted,
                        onChanged: onChanged),
                    // 高さの85%
                    Container(
                      margin: EdgeInsets.all(size.width * 0.02),
                      height: height * 0.85,
                      child: Row(
                        children: [
                          // 横幅の22%
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 高さの18%.
                              CurrentMainMenu(
                                currentMainMenuModel: currentMainMenuModel,
                              ),
                              const Spacer(),
                              // 高さの60%.
                              if (searchResult.isNotEmpty)
                                Particulars(
                                  text: currentMainMenuValue(
                                      currentMainMenuModel),
                                  child: _particularChild(),
                                )
                            ],
                          ),
                          // 横幅の3%
                          SizedBox(
                            width: width * 0.03,
                          ),
                          // 横幅の55%
                          Container(
                            width: width * 0.55,
                            child: Card(
                              child: Column(
                                children: [
                                  // message list
                                  MessageList(
                                      itemPositionsListener:
                                          itemPositionsListener,
                                      itemScrollController: _scrollController,
                                      itemCount: searchResult.length,
                                      itemBuilder: (_, index) {
                                        Widget child = SizedBox.shrink();
                                        final result = searchResult[index];
                                        if (result.type == Constants.SENDER ||
                                            result.type ==
                                                Constants.CHAT_CAROUSE ||
                                            result.type == Constants.RECEIVER
                                        ||  result.type == Constants.SUGGESTION_EVENT

                                        ) {
                                          child = _buildMsgItem(index);
                                        }
                                        return child;
                                      }),
                                  IndexElements(
                                    indexSelect: indexSelect,
                                    searchIndex: searchIndex,
                                    onUpArrowTap: () => onTapNextSearch(1),
                                    onDownArrowTap: () => onTapNextSearch(-1),
                                  ),
                                  // message box
                                  CustomMessageBoxForPC(
                                      edtMsg: edtMsg,
                                      onSendPressed: onSendPressed),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ))));
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load(Assets.BEEP);
    return await soundPool!.load(asset);
  }

  Future<void> playSound() async {
    var alarmSound = await soundId;
    alarmSoundStreamId = await soundPool!.play(alarmSound);
  }

  void showProgress() {
    loading = true;
  }

  void closeProgress() {
    loading = false;
  }

  void onClearButtonPressed() {
    setState(() {
      isSearch = false;
      searchIndex.clear();
    });
  }

  void onSubmitted(String _) {
    if (textSearch_tg == textSearch) {
      onTapNextSearch(1);
    }
  }

  void onSearchButtonPressed() {
    setState(() {
      isSearch = true;
    });
  }

  void onKeyBoardPressed() {
    setState(() {
      showMenuBar = false;
      showMenu = false;
    });
  }

  void toggleShowMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  void onMenuPressed() {
    setState(() {
      showMenuBar = true;
    });
  }

  void sendMessageToWebsocket(String msg) {
    sendMsg(msg, Constants.SENDER);
    Common.webSocketAPI?.sendMsg(Constants.MESSAGE, msg);
  }

  void onSendPressed() {
    sendMessageToWebsocket(edtMsg.text);
    edtMsg.text = '';
  }

  void onMainMenuPressed(int index) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    if (data.size.shortestSide < 550) {
      setState(() {
        currentRichMenuArea = account?.richMenuModel?.areas[index];
      });
    } else {
      setState(() {
        currentMainMenuModel = mainMenuList[index];
      });
    }

    //FBroadcast.instance().broadcast(Constants.PLAY_BEEP);
    FBroadcast.instance().broadcast(Constants.SEND_MENU_MSG, value: index);
  }

  String currentMainMenuValue(MainMenuModel? currentMainMenuModel) {
    String result = "";
    if (currentMainMenuModel != null) {
      result = currentMainMenuModel.value.startsWith('https://')
          ? ""
          : currentMainMenuModel.value;
    }
    return result;
  }

  Widget? _particularChild() {
    Widget? child;
    if (currentMainMenuModel != null) {
      if (searchResult.first.type != Constants.SENDER) {
        child = _buildMsgItem(searchResult.indexOf(searchResult.first));
      }
      if (currentMainMenuModel!.value.startsWith('https://')) {
        child = null;
      }
    }
    return child;
  }

  void onChanged(String text) {
    textSearch = text;
    if (textSearch_tg == textSearch) {
      return;
    }
    textSearch_tg = textSearch;
    searchIndex.clear();
    indexSelect = 1;

    if (text.isEmpty) {
      return;
    }
    for (int i = 0; i < allMsg.length; i++) {
      allMsg[i].rowIndex = i;
      if (allMsg[i].type == Constants.CHAT_COUNSELING_DATE_TIME) {
        continue;
      }
      if ((allMsg[i].msg ?? '').length != 0 && allMsg[i].msg!.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemChatCounseling.length != 0 &&
          allMsg[i].itemChatCounseling.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemZoomCounseling.length != 0 &&
          allMsg[i].itemZoomCounseling.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentTitle.length != 0 &&
          allMsg[i].itemHarassmentTitle.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentContent.length != 0 &&
          allMsg[i].itemHarassmentContent.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentButton1.length != 0 &&
          allMsg[i].itemHarassmentButton1.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentButton2.length != 0 &&
          allMsg[i].itemHarassmentButton2.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentPostback1.length != 0 &&
          allMsg[i].itemHarassmentPostback1.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentPostback2.length != 0 &&
          allMsg[i].itemHarassmentPostback2.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentConsultationTitle.length != 0 &&
          allMsg[i].itemHarassmentConsultationTitle.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentConsultationContent.length != 0 &&
          allMsg[i].itemHarassmentConsultationContent.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
      if (allMsg[i].itemHarassmentTimeMsg2.length != 0 &&
          allMsg[i].itemHarassmentTimeMsg2.contains(text)) {
        searchIndex.add(allMsg[i]);
      }
    }
    onTapNextSearch(0);
  }
}
