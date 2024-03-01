import 'package:flutter/material.dart';
import 'package:kirihare/page/verry_code.dart';
import 'package:kirihare/common/common.dart';

class LockOpenButton extends StatelessWidget {
  const LockOpenButton({
    Key? key,
    this.size
  }) : super(key: key);
  final double? size;
  @override 
  Widget build(BuildContext context) {
    return IconButton(
    onPressed: () {
      print(Common.userPhone);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => VerryCodePage(
                userId: Common.userId,
                phone: Common.userPhone,
                sendCheck: 'PHONE_ADD',
              )));
    },
    icon: Icon(Icons.lock_open_outlined,size: size,),
    );
  }
}