import 'package:flutter/material.dart';
import 'package:kirihare/model/msg_model.dart';

class CurrentIndexText extends StatelessWidget {
  const CurrentIndexText({
    Key? key,
    required this.indexSelect,
    required this.searchIndex
  }) : super(key: key);
  final int indexSelect;
  final List<MsgModel> searchIndex;
  @override 
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "${indexSelect != 0 ? indexSelect : "1"}/${searchIndex.length}",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}