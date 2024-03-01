import 'package:flutter/material.dart';
import 'package:kirihare/common/AppColors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:kirihare/model/msg_model.dart';
import 'package:kirihare/adapter/msg_adapter.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    Key? key,
    required this.itemPositionsListener,
    required this.itemScrollController,
    required this.itemCount,
    required this.itemBuilder
  }) : super(key: key);
  final ItemPositionsListener? itemPositionsListener;
  final ItemScrollController? itemScrollController;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  @override 
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: AppColors.chatBg),
        child: ScrollablePositionedList.builder(
          itemPositionsListener: itemPositionsListener,
          itemScrollController: itemScrollController,
          itemCount: itemCount,
          shrinkWrap: true,
          reverse: true,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}