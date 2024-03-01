import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quick_notify/quick_notify.dart';

enum ChatRegType {
  LINK, IMG
}

extension ChatRegTypeExtension on ChatRegType {
  String get reg {
    switch (this) {
      case ChatRegType.LINK:
        return r'\[LINK:(.*?)\]';
      case ChatRegType.IMG:
        return r'\[IMG:(.*?)\]';
    }
  }
}

class Utils {
  static String? pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'];
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  static String getMillisecond() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String getFormattedDate(DateTime dateTime) {
    final DateFormat dateFormat = new DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(dateTime);
  }

  static String chatRegUrl(String text, ChatRegType regType) {
    final RegExp urlRegExp = RegExp(regType.reg);
    var matches = urlRegExp.firstMatch(text);
    if (matches != null) {
      var str = text.substring(matches.start, matches.end);
      if (str.isNotEmpty) {
        return str.substring(0, str.length - 1).replaceAll("[${regType.name}:", "");
      }
    }
    return "";
  }

  static String chatRemoveRegTypeStr(String text) {
    ChatRegType.values.forEach((element) {
        var index = text.indexOf("[${element.name}");
        if (index > -1) {
          text = text.substring(0, index);
        }
    });
    return text;
  }


  static List<String> getSplittedText(String text) {
    final RegExp urlRegExp = RegExp(
        r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');
    final Iterable<RegExpMatch> urlMatches = urlRegExp.allMatches(text);

    final List<String> splittedMessage = <String>[];
    String textEnd = ''; // 文末（文末の分割を繰り返していく）
    int count = 0; // Iterableのためcount

    if (urlMatches.length == 0) {
      splittedMessage.add(text);
    }

    for (RegExpMatch urlMatch in urlMatches) {
      final String url = text.substring(urlMatch.start, urlMatch.end);
      List<String> splittedText;

      if (count == 0) {
        splittedText = text.split(url);
      } else {
        splittedText = textEnd.split(url);
      }

      count++;

      if (splittedText[0] != url) {
        splittedMessage.add(splittedText[0]);
      }
      splittedMessage.add(url);

      textEnd = splittedText.last;
    }

    if (textEnd != '') {
      splittedMessage.add(textEnd);
    }

    return splittedMessage;
  }
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showNotificationToDesktop(String message) async {
  QuickNotify.notify(
    title: message,
    content: message,
  );
}
