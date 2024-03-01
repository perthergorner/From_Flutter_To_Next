
import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kirihare/adapter/self_check_on_mind_adapter.dart';
import 'package:kirihare/adapter/stretching_mind_adapter.dart';
import 'package:kirihare/common/AppColors.dart';
import 'package:kirihare/common/common.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/model/carousel_model.dart';
import 'package:kirihare/model/msg_model.dart';
import 'package:kirihare/page/chat_components/responsive/for_pc/msg_cards_for_pc.dart';
import 'package:kirihare/page/chat_components/responsive/for_phone/msg_cards_for_phone.dart';
import 'package:kirihare/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../model/Browser.dart';
import '../page/chat_components/CustomScrollViewWidget.dart';
import '../page/chat_components/SuggestionListView.dart';

class MessageAdapter {
  BorderRadiusGeometry getMsgViewBorder(MsgModel model) {
    if (model.type != Constants.SENDER) {
      return BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20));
    }

    return BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
        topRight: Radius.circular(0));
  }

  EdgeInsetsGeometry getMsgMargin(MsgModel model) {
    if (model.type == Constants.RECEIVER) {
      return EdgeInsets.only(left: 0, right: 50);
    }
    return EdgeInsets.only(left: 50, right: 0);
  }

  Widget msgItem(BuildContext context, MsgModel model) {
    return Container(
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (model.type != Constants.SENDER 
                || model.type == Constants.RECEIVER)
                && Common.device == Constants.SMART_PHONE
                ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ClipOval(
                      child: Image.asset('assets/images/avatar.png',
                          fit: BoxFit.cover, width: 25),
                    ))
                : Container(),
            Expanded(child: _msgItem(context, model)),
          ],
        ));
  }

  Widget _msgItem(BuildContext context, MsgModel model) {
    final bool isSmartPhone = Common.device == Constants.SMART_PHONE;
    final _msgItemPadding = EdgeInsets.only(
      right: isSmartPhone ? 16 : 0, 
      top: 5, 
      bottom: 5
    );
    EdgeInsetsGeometry? _rightMargin(double right) {
      return
      EdgeInsets.only(right: isSmartPhone ? right : 0);
    }

    if (model.type == Constants.SELF_CHECK_ON_MIND) { // 心のセルフチェック.
      final int itemCount = model.menuSelfCheckOnMindList.length;
      Widget child(int index) => SelfCheckOnMindAdapter().menuItem(
        model.menuSelfCheckOnMindList[index], index);
      return Common.device == Constants.SMART_PHONE
        ? MsgCardsForPhone(itemCount: itemCount, child: child)
        : MsgCardsForPC(itemCount: itemCount, child: child);
    }

    if (model.type == Constants.STRETCHING_MIND) { // 心のストレッチ.
      final int itemCount = model.menuStretchingList.length;
      Widget child(int index) => StretchingMindAdapter()
        .menuItem(model.menuStretchingList[index], index);
      return Common.device == Constants.SMART_PHONE
        ? MsgCardsForPhone(itemCount: itemCount, child: child)
        : MsgCardsForPC(itemCount: itemCount, child: child);
    }

    if (model.type == Constants.MINUTES_PER_CONSULTANT) { // オンライン保健室.
      return Container(
        padding: _msgItemPadding,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 250,
            decoration: BoxDecoration(
                border: model.selectFlag
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
                borderRadius: getMsgViewBorder(model),
                color: AppColors.colorFriendMsg),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topRight: Radius.circular(15)),
                        color: Colors.green),
                    child: Center(
                        child: SelectableText(model.msg ?? '',
                            style: TextStyle(
                                color: Color.fromARGB(255, 22, 22, 22))))),
                Column(
                  children: model.postbackList.map((e) {
                    return InkWell(
                        onTap: () {
                          if (e.postback == "電話カウンセリング") {
                            Common.chatCounseling = e.postback;
                            FBroadcast.instance().broadcast(
                                Constants.CHAT_COUNSELING,
                                value: Constants.SELECT_RESERVATION_DATE);
                            // chat

                          } else if (e.postback == "チャットカウンセリング") {
                            Common.chatCounseling = e.postback;
                            FBroadcast.instance().broadcast(
                                Constants.CHAT_COUNSELING,
                                value: Constants.SELECT_RESERVATION_DATE);
                            // time

                          } else if (e.postback == "ビデオ通話カウンセリング") {
                            Common.chatCounseling = e.postback;
                            FBroadcast.instance().broadcast(
                                Constants.ZOOM_COUNSELING,
                                value: Constants.SELECT_RESERVATION_DATE);
                          }
                          Common.webSocketAPI?.sendCounselingMsg(
                              Constants.POSTBACK, e.postback);
                        },
                        child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            width: double.infinity,
                            color: AppColors.whiteBlue,
                            child: Center(child: Text(e.postback))));
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // chat counseling
    if (model.type == Constants.CHAT_COUNSELING_DATE_TIME) {
      // ignore: unnecessary_null_comparison
      var onTap = () {
        FBroadcast.instance().broadcast(
            Constants.CHAT_COUNSELING_CALENDAR,
            value: model.postback);
      };
      if (model.msg == null) {
        model.msg = " ご予約";
      }
      return Container(
        padding: _msgItemPadding,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: _rightMargin(100.0),
            decoration: BoxDecoration(
                border: model.selectFlag
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
                borderRadius: getMsgViewBorder(model),
                color: AppColors.colorFriendMsg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBuildWithContainer(model.msg ?? '',
                    EdgeInsets.only(top: 16, left: 16),
                      textSearch: model.textSearch,
                      bGText: model.colorSelect,
                      fontWeight: FontWeight.bold),
                SizedBox(height: 10),
                textBuildWithContainer(
                  'ご予約日を選択してください',
                  EdgeInsets.only(left: 16),
                  textSearch: model.textSearch,
                  bGText: model.colorSelect,
                ),
                SizedBox(height: 20),
                InkWell(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                      ),
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child:
                      Center(
                          child: textBuild('カレンダーから選択する',
                              textSearch: model.textSearch,
                              bGText: model.colorSelect,
                              colorText: Colors.blue,
                              onTap: onTap
                                  )),
                      ))
              ],
            ),
          ),
        ),
      );
    }

    // zoom counseling
    if (model.type == Constants.ZOOM_COUNSELING_DATE_TIME) {
      print("Zoom Counseling Calendar: ${model.postback}");

      var onTap = () {
        FBroadcast.instance().broadcast(
            Constants.ZOOM_COUNSELING_CALENDAR,
            value: model.postback);
      };
      return Container(
        padding: _msgItemPadding,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: _rightMargin(100.0),
            decoration: BoxDecoration(
                border: model.selectFlag
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
                borderRadius: getMsgViewBorder(model),
                color: AppColors.colorFriendMsg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBuildWithContainer("ビデオ通話カウンセリング_予約日時",
                    EdgeInsets.only(top: 16, left: 16),
                    textSearch: model.textSearch,
                    bGText: model.colorSelect,
                    fontWeight: FontWeight.bold),
                SizedBox(height: 10),
                textBuildWithContainer(
                  'ご予約日を選択してください 。',
                  EdgeInsets.only(left: 16),
                  textSearch: model.textSearch,
                  bGText: model.colorSelect,
                ),
                SizedBox(height: 20),
                InkWell(
                    onTap: onTap,
                    child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Center(
                            child: textBuild("'カレンダーから選択する'",
                            textSearch: model.textSearch,
                            bGText: model.colorSelect,
                            colorText: Colors.blue,
                          onTap: onTap
                        ))))
              ],
            ),
          ),
        ),
      );
    }

    if (model.type == Constants.HARASSMENT_COUNSELING) {
      return Container(
        padding: _msgItemPadding,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: _rightMargin(100.0),
            decoration: BoxDecoration(
                border: model.selectFlag
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
                borderRadius: getMsgViewBorder(model),
                color: AppColors.colorFriendMsg),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Center(
                      child: textBuild(model.itemHarassmentTitle,
                          textSearch: model.textSearch,
                          bGText: model.colorSelect,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          colorText: Colors.black)
                      // SelectableText(model.msg, style: TextStyle(fontSize: 13, color: Colors.black)) /*LinkWell(model.msg, style: TextStyle(fontSize: 13, color: Colors.black),)*/
                      ),
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: 15, 
                      right: isSmartPhone ? 15 : 0, 
                      bottom: 5
                    ),
                    child: Center(
                        child: textBuild(model.itemHarassmentContent,
                            textSearch: model.textSearch,
                            bGText: model.colorSelect,
                            colorText: Colors
                                .black))), //SelectableText(model.itemHarassmentContent,
                // style: TextStyle(color: Colors.black)))),
                Divider(),
                InkWell(
                    onTap: () {
                      Common.harassmentPostback1 =
                          model.itemHarassmentPostback1;
                      Common.webSocketAPI?.sendHarassmentPostbackMsg(
                          Constants.POSTBACK, model.itemHarassmentPostback1);
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Center(
                            child: textBuild(model.itemHarassmentButton1,
                                textSearch: model.textSearch,
                                bGText: model.colorSelect,
                                colorText: Colors.blue,
                                onTap: (){
                                  Common.harassmentPostback1 =
                                      model.itemHarassmentPostback1;
                                  Common.webSocketAPI?.sendHarassmentPostbackMsg(
                                      Constants.POSTBACK, model.itemHarassmentPostback1);
                                })))
                ),
                SizedBox(height: 1),
                InkWell(
                    onTap: () {
                      Browser.openWebBrowser(model.itemHarassmentPostback2);
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Center(
                              child: textBuild(model.itemHarassmentButton2,
                                  textSearch: model.textSearch,
                                  bGText: model.colorSelect,
                                  colorText: Colors.blue,
                                onTap: () {
                                  Browser.openWebBrowser(model.itemHarassmentPostback2);
                                }
                                  ),
                            ))), //Text(model.itemHarassmentButton2,
                // style: TextStyle(color: Colors.blue))
              ],
            ),
          ),
        ),
      );
    }

    if (model.type == Constants.HARASSMENT_COUNSELING_RESPONSE) {
      return Container(
          padding:  EdgeInsets.only(
            right: isSmartPhone ? 16 : 0, 
            top: 5, 
            bottom: 5, 
            left: 16
          ),
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: _rightMargin(100.0),
                  padding:
                      EdgeInsets.only(
                        top: 10, 
                        bottom: 10, 
                        left: 20, 
                        right: isSmartPhone ? 20 : 0,
                      ),
                  decoration: BoxDecoration(
                      border: model.selectFlag
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                      borderRadius: getMsgViewBorder(model),
                      color: AppColors.colorFriendMsg),
                  child: Column(children: [
                    textBuild(model.itemHarassmentConsultationTitle,
                        textSearch: model.textSearch,
                        bGText: model.colorSelect,
                        colorText: Colors.black)
                  ]))));
    }

    if (model.type == Constants.HARASSMENT_TIME_MSG) {
      return Container(
          padding: _msgItemPadding,
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: _rightMargin(60.0),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: isSmartPhone ? 20 : 0),
                  decoration: BoxDecoration(
                      border: model.selectFlag
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                      borderRadius: getMsgViewBorder(model),
                      color: AppColors.colorFriendMsg),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textBuild(model.itemHarassmentTimeMsg1,
                            textSearch: model.textSearch,
                            bGText: model.colorSelect,
                            colorText: Colors
                                .black) // SelectableText(model.msg, style: TextStyle(fontSize: 13, color: Colors.black)) /*LinkWell(model.msg, style: TextStyle(fontSize: 13, color: Colors.black),)*/
                        ,
                        SizedBox(height: 10),
                        textBuild(model.itemHarassmentTimeMsg2,
                            textSearch: model.textSearch,
                            bGText: model.colorSelect,
                            colorText: Colors
                                .black) // SelectableText(model.msg, style: TextStyle(fontSize: 13, color: Colors.black)) /*LinkWell(model.msg, style: TextStyle(fontSize: 13, color: Colors.black),)*/
                        ,
                      ]))));
    }

    if (model.type == Constants.FREQUENCY_MSG) {
      return Container(
          padding: _msgItemPadding,
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: _rightMargin(60.0),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: isSmartPhone ? 20 : 0),
                  decoration: BoxDecoration(
                      border: model.selectFlag
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                      borderRadius: getMsgViewBorder(model),
                      color: AppColors.colorFriendMsg),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        textBuild(model.freqTitle,
                            textSearch: model.textSearch,
                            bGText: model.colorSelect,
                            colorText: Colors
                                .black) // SelectableText(model.msg, style: TextStyle(fontSize: 13, color: Colors.black)) /*LinkWell(model.msg, style: TextStyle(fontSize: 13, color: Colors.black),)*/
                        ,
                        SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              FBroadcast.instance().broadcast(
                                  Constants.FREQ_DURING_WORKING_HOURS,
                                  value: model);
                            },
                            child: textBuild(model.freqMsg_1,
                                textSearch: model.textSearch,
                                bGText: model.colorSelect,
                                colorText: Colors
                                    .black)) // SelectableText(model.msg, style: TextStyle(fontSize: 13, color: Colors.black)) /*LinkWell(model.msg, style: TextStyle(fontSize: 13, color: Colors.black),)*/
                        , //Text(model.freqMsg_1)),
                        TextButton(
                            onPressed: () {
                              FBroadcast.instance().broadcast(
                                  Constants.FREQ_DURING_WORKING_OUT,
                                  value: model);
                            },
                            child: Text(model.freqMsg_2)),
                      ]))));
    }

    if (model.type == Constants.HARASSMENT_OCCURRENCE_TIME_MSG) {
      return Container(
          padding: _msgItemPadding,
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: _rightMargin(60.0),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: isSmartPhone ? 20 : 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: AppColors.colorFriendMsg),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: model.selectFlag
                                  ? Border.all(color: Colors.blue, width: 2)
                                  : null,
                              borderRadius: getMsgViewBorder(model),
                            ),
                            child: textBuild(model.harassment_occurrence_title,
                                textSearch: model.textSearch,
                                bGText: model.colorSelect,
                                colorText: Colors
                                    .black) // SelectableText(model.msg, style: TextStyle(fontSize: 13, color: Colors.black)) /*LinkWell(model.msg, style: TextStyle(fontSize: 13, color: Colors.black),)*/
                            ),
                        SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              FBroadcast.instance().broadcast(
                                  Constants.FREQ_DURING_WORKING_HOURS,
                                  value: model);
                            },
                            child: Text(
                                model.harassment_occurrence_breaking_time)),
                        TextButton(
                            onPressed: () {},
                            child:
                                Text(model.harassment_occurrence_after_work)),
                        TextButton(
                            onPressed: () {},
                            child: Text(model.harassment_occurrence_holiday)),
                        TextButton(
                            onPressed: () {
                              FBroadcast.instance().broadcast(
                                  Constants.FREQ_DURING_WORKING_HOURS_OUT,
                                  value: model);
                            },
                            child: Text(model.harassment_occurrence_others)),
                      ]))));
    }

    if (model.type == Constants.CHAT_CAROUSE) {
      return CustomCarouselView(model: model);
    }
    if (model.type == Constants.SUGGESTION_EVENT) {
      String processedMsg = model.msg!;
      var suggestions = processedMsg.split(',').map((s) => s.trim()).toList();
      return SuggestionListView(suggestions: suggestions);
    }


    // show text send
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Align(
          alignment: (model.type == Constants.RECEIVER
              ? Alignment.topLeft
              : Alignment.topRight),
          child: Container(
              margin: getMsgMargin(model),
              decoration: BoxDecoration(
                  border: model.selectFlag
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                  borderRadius: getMsgViewBorder(model),
                  color: (model.type == Constants.RECEIVER
                      ? AppColors.colorFriendMsg
                      : AppColors.colorMyMsg)),
              padding: EdgeInsets.all(16),
              child: textBuildBk(model.msg ?? '',
                  textSearch: model.textSearch,
                  bGText: model.colorSelect,
                  colorText: Colors
                      .black) // SelectableText(model.msg, style: TextStyle(fontSize: 13, color: Colors.black)) /*LinkWell(model.msg, style: TextStyle(fontSize: 13, color: Colors.black),)*/
          ),
        ));
  }

  Widget textBuildWithContainer(String text, EdgeInsetsGeometry padding,
      {String? textSearch,
        Color? colorText,
        Color? bGText,
        double? fontSize = 13,
        fontWeight,
        GestureTapCallback? onTap = null
      }) {
    return Container(
      padding: padding,
      child: textBuild(text, textSearch: textSearch,
          colorText: colorText,
          bGText: bGText,
          fontSize: fontSize,
          fontWeight: fontWeight,
        onTap: onTap
      ),
    );
  }

  Widget textBuild(String text,
      {String? textSearch,
        Color? colorText,
        Color? bGText,
        double? fontSize = 13,
        fontWeight,
        GestureTapCallback? onTap = null
      }) {
    List<TextSpan> list = [];
    int startIndex;
    String resultEnd = "";
    String resultSart = "";
    String resultMid = "";
    if (text.length == 0) {
      return Container();
    }
    if (textSearch != null) {
      String tgText = text;
      startIndex = tgText.toLowerCase().indexOf(textSearch);
      resultEnd = text.substring(startIndex + textSearch.length);
      resultSart = text.substring(0, startIndex != -1 ? startIndex : 0);
      resultMid =
          text.substring(resultSart.length, startIndex + textSearch.length);
      list.add(
        TextSpan(
            text: resultSart,
            style: TextStyle(
                color: colorText ?? Colors.black,
                fontSize: fontSize,
                fontWeight: fontWeight)),
      );
      if (startIndex != -1) {
        list.add(
          TextSpan(
              text: resultMid,
              style: TextStyle(
                  color: colorText ?? Colors.black,
                  fontSize: fontSize,
                  backgroundColor: bGText)),
        );
      }
      list.add(
        TextSpan(
            text: resultEnd,
            style: TextStyle(
                color: colorText ?? Colors.black,
                fontSize: fontSize,
                fontWeight: fontWeight)),
      );
    } else {
      int splittedTextIndex = 0;
      List<String> splittedTexts = Utils.getSplittedText(text);
      for (String splittedText in splittedTexts) {
        if (splittedTextIndex % 2 == 0) {
          list.add(
            TextSpan(
                text: splittedText,
                style: TextStyle(
                    color: colorText ?? Colors.black,
                    fontSize: fontSize,
                    backgroundColor: bGText,
                    fontWeight: fontWeight)),
          );
        } else {
          list.add(
              TextSpan(
                text: splittedText,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: fontSize,
                    backgroundColor: bGText,
                    fontWeight: fontWeight),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(splittedText);
                  }),
          );
        }
        splittedTextIndex++;
      }
    }


    if (onTap != null) {
      return RichText(text: TextSpan(children: list));
    }
    return SelectableText.rich(
      TextSpan(children: list)
    );
  }


  Widget textBuildBk(String text,
      {String? textSearch,
        Color? colorText,
        Color? bGText,
        double? fontSize = 13,
        fontWeight}) {
    List<InlineSpan> list = [];
    List<InlineSpan> imageWidgets = [];
    int startIndex;
    String resultEnd = "";
    String resultSart = "";
    String resultMid = "";

    if (text.length == 0) {
      return Container();
    }
    if (textSearch != null) {
      String tgText = text;
      startIndex = tgText.toLowerCase().indexOf(textSearch);
      if (startIndex > -1) {
        resultEnd = text.substring(startIndex + textSearch.length);
        resultSart = text.substring(0, startIndex != -1 ? startIndex : 0);
        resultMid =
            text.substring(resultSart.length, startIndex + textSearch.length);
        list.add(
          TextSpan(
              text: resultSart,
              style: TextStyle(
                  color: colorText ?? Colors.black,
                  fontSize: fontSize,
                  fontWeight: fontWeight)),
        );
      }
      if (startIndex != -1) {
        list.add(
          TextSpan(
              text: resultMid,
              style: TextStyle(
                  color: colorText ?? Colors.black,
                  fontSize: fontSize,
                  backgroundColor: bGText)),
        );
      }
      list.add(
        TextSpan(
            text: resultEnd,
            style: TextStyle(
                color: colorText ?? Colors.black,
                fontSize: fontSize,
                fontWeight: fontWeight)),
      );
    } else {
      var defaultTextStyle = TextStyle(
          color: colorText ?? Colors.black,
          fontSize: fontSize,
          backgroundColor: bGText,
          fontWeight: fontWeight);
      var clickableTextStyle = TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: fontSize,
                      backgroundColor: bGText,
                      fontWeight: fontWeight);
      var normalText = Utils.chatRemoveRegTypeStr(text);
      var linkUrl = Utils.chatRegUrl(text, ChatRegType.LINK);
      var imageUrl = Utils.chatRegUrl(text, ChatRegType.IMG);
      if (normalText.isNotEmpty) {
        list.add(TextSpan(text: normalText, style: defaultTextStyle));
      }
      if (linkUrl.isEmpty && imageUrl.isNotEmpty) {
        list.add(_clickableTextSpan(imageUrl, clickableTextStyle));
      }
      if (linkUrl.isNotEmpty && imageUrl.isNotEmpty) {
        imageWidgets.add(
            WidgetSpan(child: _clickableImage(imageUrl, linkUrl, _clickableRichText(imageUrl, clickableTextStyle)))
        );
      }

    }
    if (imageWidgets.isNotEmpty) {
      return RichText(
        text: TextSpan(
            children: list + imageWidgets
        ),
      );
    }


    return SelectableText.rich(
      TextSpan(children: list + imageWidgets),
    );
  }

  Widget _clickableImage(String imageUrl, String linkUrl, Widget errorWidget) {
    return GestureDetector(
      onTap: () {
        launchUrlString(linkUrl);
      },
      child: Image.network(imageUrl, errorBuilder: (c, e, s) {
        return errorWidget;
      }),
    );
  }

  Widget _clickableRichText(String text, TextStyle style) {
    return RichText(
        text: _clickableTextSpan(text, style)
    );
  }

  InlineSpan _clickableTextSpan(String text, TextStyle style) {
    return TextSpan(text: text,
        style: style,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrlString(text);
          });
  }
}
