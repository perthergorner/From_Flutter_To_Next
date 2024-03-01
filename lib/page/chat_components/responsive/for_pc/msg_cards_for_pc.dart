import 'package:flutter/material.dart';

class MsgCardsForPC extends StatelessWidget {
  const MsgCardsForPC({
    Key? key,
    required this.itemCount,
    required this.child
  }) : super(key: key);
  final int itemCount;
  final Widget Function(int) child;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
        padding:
            const EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 16),
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: child(index),
              );
            }),
      );
  }
}