import 'package:flutter/material.dart';
import 'package:kirihare/page/chat_components/index_elements/components/index_arrow.dart';
import 'package:kirihare/page/chat_components/index_elements/components/current_index_text.dart';
import 'package:kirihare/model/msg_model.dart';

class IndexElements extends StatelessWidget {
  const IndexElements({
    Key? key,
    required this.indexSelect,
    required this.searchIndex,
    required this.onUpArrowTap,
    required this.onDownArrowTap,
  }) : super(key: key);
  final int indexSelect;
  final List<MsgModel> searchIndex;
  final void Function()? onUpArrowTap;
  final void Function()? onDownArrowTap;
  @override 
  Widget build(BuildContext context) {
    return Visibility(
visible: searchIndex.length != 0,
child: Container(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          color: Colors.black,
          width: 0.1,
        ))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CurrentIndexText(indexSelect: indexSelect, searchIndex: searchIndex),
        IndexArrow(
          onTap: onUpArrowTap,
          quarterTurns: 1,
          rightPadding: 0,
        ),
        IndexArrow(
          onTap: onDownArrowTap,
          quarterTurns: 3,
          rightPadding: 10,
        )
      ],
    )));
  }
}