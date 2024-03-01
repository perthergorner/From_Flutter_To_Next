import 'package:flutter/material.dart';
import 'package:kirihare/common/shadow.dart';
import 'package:kirihare/page/chat_components/help_button.dart';
import 'package:kirihare/page/chat_components/lock_open_button.dart';

class SearchFieldForPC extends StatelessWidget {
  const SearchFieldForPC({
    Key? key,
    required this.searchFocusNode,
    required this.onSubmitted,
    required this.onChanged
  }) : super(key: key);
  final FocusNode searchFocusNode;
  final ValueChanged<String>?  onSubmitted;
  final ValueChanged<String>?  onChanged;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: (size.width * 0.80) - 50,
          height: size.height * 0.1,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: basicShadow
            ),
            child: Card(
              child: TextField(
                focusNode: searchFocusNode,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,color: Colors.black,),
                  suffixIconConstraints:
                      BoxConstraints(minWidth: 40, minHeight: 40),
                  hintText: "Search",
                  border: InputBorder.none, // 下線を非表示にする
                ),
              ),
            ),
          ),
        ),
        const LockOpenButton(size: 30,),
        const HelpButton(size: 30,),
      ],
    );
  }
}