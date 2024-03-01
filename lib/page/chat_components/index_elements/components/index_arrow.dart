import 'package:flutter/material.dart';

class IndexArrow extends StatelessWidget {
  const IndexArrow({
    Key? key,
    required this.onTap,
    required this.quarterTurns,
    required this.rightPadding
  }) : super(key: key);
  final void Function()? onTap;
  final int quarterTurns;
  final double rightPadding;
  @override 
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 10,right: rightPadding),
        child: RotatedBox(
            quarterTurns: quarterTurns,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey,
            )),
      )
    );
  }
}