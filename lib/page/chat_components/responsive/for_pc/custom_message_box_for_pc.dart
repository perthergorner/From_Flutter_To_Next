import 'package:flutter/material.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/common/shadow.dart';

class CustomMessageBoxForPC extends StatelessWidget {
  const CustomMessageBoxForPC({
    Key? key,
    required this.edtMsg,
    required this.onSendPressed
  }) : super(key: key);
  final TextEditingController edtMsg;
  final void Function()? onSendPressed;
  @override 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: basicShadow,
        color: Colors.white,
      ),
      height: size.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                    height: (size.height * 0.2) - 24,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: null,
                  controller: edtMsg,
                  decoration: InputDecoration(
                      hintText: 'Enter a message',
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
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Transform.rotate(
                  angle: 45 * Constants.rad, // 角度をラジアンに変換
                  child: Icon(Icons.attach_file),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.image_outlined),
              ),
              Icon(Icons.mic),
            ],
          )
        ],
      ),
    );
  }
}