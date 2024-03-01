import 'package:flutter/material.dart';

class CustomMessageBoxForPhone extends StatelessWidget {
  const CustomMessageBoxForPhone({
    Key? key,
    required this.onMenuPressed,
    required this.edtMsg,
    required this.onSendPressed
  }) : super(key: key);
  final void Function()? onMenuPressed;
  final TextEditingController edtMsg;
  final void Function()? onSendPressed;
  @override 
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 10, bottom: 3, top: 3, right: 10),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: onMenuPressed,
              icon: Icon(Icons.menu)),
          SizedBox(width: 5),
          Expanded(
              child: Container(
            child: TextField(
              maxLines: null,
              minLines: null,
              controller: edtMsg,
              decoration: InputDecoration(
                  hintText: 'メッセージを書く',
                  hintStyle: TextStyle(
                      color: Colors.black54, fontSize: 13),
                  border: InputBorder.none),
            ),
          )),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: onSendPressed,
            child: Icon(Icons.send,
                color: Colors.white, size: 18),
            backgroundColor: Colors.green,
            elevation: 0,
            mini: true,
          )
        ],
      ),
    );
  }
}