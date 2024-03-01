import 'dart:async';
import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:kirihare/common/common.dart';
import 'package:kirihare/common/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketAPI {
  late WebSocketChannel _channel;
  String command = '';
  String _userId = "";
  bool isOpenMenu = false;
  String value = '';
  final List<String> messageQueue = [];
  bool isChannelOpen = false;
  DateTime? pingDate;
  static WebSocketAPI? _instance;

  WebSocketAPI._internal() {
    init(_userId);
  }

  factory WebSocketAPI() {
    if (_instance == null) {
      _instance = WebSocketAPI._internal();
    }
    return _instance!;
  }

  void reconnect() {
    // 再接続の試行間隔を設定する
    Future.delayed(Duration(seconds: 2), () {
      if (!isChannelOpen) {
        _channel.sink.close();
        init(_userId);
      }
    });
  }

  void sendQueuedMessages() {
    // 再接続後、キューに溜まったメッセージを送信
    if (isChannelOpen && messageQueue.isNotEmpty) {
      messageQueue.forEach((message) {
        _channel.sink.add(message);
      });
      messageQueue.clear();
    }
  }

  void init(String userId) {
    if (userId == '') {
      return;
    }
    if (isChannelOpen) {
      return;
    }
    _userId = userId;
    String url = Constants.WEB_SOCKET_URI;
    Uri urlp = Uri.parse('$url$userId');
    _channel = WebSocketChannel.connect(urlp);
    isChannelOpen = true;

    _channel.stream.listen(
      (message) {
        isChannelOpen = true;
        final res = message.toString();
        print("res: ${res}");

        if (res.isEmpty) return;

        if (res == Constants.YOU_ARE_CONNECTED) {
          FBroadcast.instance().broadcast(Constants.YOU_ARE_CONNECTED);
          return;
        }


        final jsonRes = jsonDecode(res);

        if (command == Constants.SOCKET_MSG_GET_USAGE_MENU) {
          FBroadcast.instance()
              .broadcast(Constants.WEB_SOCKET_MAIN_MENU, value: jsonRes);
          isOpenMenu = true;
        }

        if (jsonRes["type"] == Constants.TYPE_PING) {
          pingDate = DateTime.now();
        }
        if (jsonRes["type"] == Constants.CHAT) {
          FBroadcast.instance().broadcast(Constants.CHAT, value: jsonRes);
        }
        if (jsonRes["type"] == Constants.SUGGESTION_EVENT) {
          var suggestionsText = jsonRes["message"] as String;
          FBroadcast.instance().broadcast(Constants.SUGGESTION_EVENT, value: suggestionsText);
        }

        if (jsonRes["value"] != null && jsonRes["value"] != "") {
          var res = jsonDecode(jsonRes["value"]);
          if (res['type'] == Constants.CAROUSE) {
            FBroadcast.instance()
                .broadcast(Constants.CAROUSE, value: res['value']);
          }
        }

        if (command == Common.menu3) {
          FBroadcast.instance().broadcast(
              Constants.HARASSMENT_COUNSELING_INQUIRY,
              value: jsonRes);
        }

        if (command == Common.menu1) {
          FBroadcast.instance().broadcast(
              Constants.WEB_SOCKET_SELF_CHECK_ON_MIND,
              value: jsonRes);
        }

        if (command == Common.menu4) {
          FBroadcast.instance()
              .broadcast(Constants.WEB_SOCKET_STRETCHING_MINID, value: jsonRes);
        }

        if (command == Common.menu2) {
          FBroadcast.instance()
              .broadcast(Constants.WEB_SOCKET_LINE_HEALTH_ROOM, value: jsonRes);
        }

        if (command == Common.chatCounseling) {
          FBroadcast.instance()
              .broadcast(Constants.WEB_SOCKET_CHAT_COUNSELING, value: jsonRes);
        }

        if (command == Common.zoomCounseling) {
          FBroadcast.instance()
              .broadcast(Constants.WEB_SOCKET_ZOOM_COUNSELING, value: jsonRes);
        }

        if (command == Common.chatCounselingTime) {
          FBroadcast.instance().broadcast(
              Constants.CHAT_COUNSELING_RESERVE_TIME,
              value: jsonRes);
        }

        if (command == Common.zoomCounselingTime) {
          FBroadcast.instance().broadcast(
              Constants.ZOOM_COUNSELING_RESERVE_TIME,
              value: jsonRes);
        }

        if (command == Common.harassmentPostback1) {
          FBroadcast.instance()
              .broadcast(Constants.HARASSMENT_POSTBACK, value: jsonRes);
        }

        if (command == Common.harassmentPostback2) {
          FBroadcast.instance()
              .broadcast(Constants.HARASSMENT_POSTBACK, value: jsonRes);
        }

        if (command == Common.harassmentTime) {
          FBroadcast.instance()
              .broadcast(Constants.HARASSMENT_TIME, value: jsonRes);
        }

        if (command == Constants.frequency) {
          FBroadcast.instance()
              .broadcast(Constants.FREQUENCY_MSG, value: jsonRes);
        }

        if (command == Common.freqDuringWorkHoursOut) {
          FBroadcast.instance().broadcast(
              Constants.WHICH_TIME_IN_HARASSMENT_OCCURRENCE,
              value: jsonRes);
        }
      },
      onDone: () {
        isChannelOpen = false;
        reconnect();
      },
      onError: (error) {
        print("WebSocket error: $error");
        isChannelOpen = false;
        reconnect(); // エラー発生時に再接続を試みる
      },
    );
  }

  void queueMessage(String message) {
    if (!isChannelOpen) {
      messageQueue.add(message);
    } else {
      _channel.sink.add(message);
    }
  }

  void sendMsg(String type, String message) {
    command = message;
    final Map<String, dynamic> msg = {
      Constants.DISPLAY_TYPE: Common.device,
      Constants.type: type,
      Constants.MESSAGE: message
    };
    queueMessage(jsonEncode(msg));
  }

  void sendHarassmentPostbackMsg(String type, String message) {
    command = message;
    final Map<String, dynamic> msg = {
      Constants.DISPLAY_TYPE: Common.device,
      Constants.type: type,
      Constants.POSTBACK: message
    };
    queueMessage(jsonEncode(msg));
  }

  void sendFreqDuringWorkingHoursOut(String message) {
    command = message;
    final Map<String, dynamic> msg = {
      Constants.DISPLAY_TYPE: Common.device,
      Constants.POSTBACK: message
    };
    queueMessage(jsonEncode(msg));
  }

  void sendFrequencyMsg(String type, String message) {
    command = message;
    final Map<String, dynamic> msg = {
      Constants.DISPLAY_TYPE: Common.device,
      Constants.POSTBACK: message
    };
    queueMessage(jsonEncode(msg));
  }

  void sendHarassmentTime(String type, String message) {
    command = message;
    final Map<String, dynamic> msg = {
      Constants.DISPLAY_TYPE: Common.device,
      Constants.DATE_TIME: type,
      Constants.POSTBACK: message
    };
    queueMessage(jsonEncode(msg));
  }

  void sendCounselingTime(String type, String message) {
    command = message;
    final Map<String, dynamic> msg = {
      Constants.DISPLAY_TYPE: Common.device,
      Constants.DATE_TIME: type,
      Constants.POSTBACK: message
    };
    queueMessage(jsonEncode(msg));
  }

  void sendCounselingMsg(String type, String message) {
    command = message;
    final Map<String, dynamic> msg = {
      Constants.DISPLAY_TYPE: Common.device,
      Constants.type: type,
      Constants.POSTBACK: message
    };
    queueMessage(jsonEncode(msg));
  }

  void checkConnection() {
    if (pingDate == null) return;
    var now = DateTime.now();
    // Calculate the difference between two DateTime objects
    Duration difference = now.difference(pingDate!);
    // Check if the difference is less than or equal to 30 seconds
    if (difference.inSeconds <= 30) {
      return;
    }
    pingDate = null;
    _channel.sink.close();
    isChannelOpen = false;
    reconnect(); // 再接続を試みる
  }
}
