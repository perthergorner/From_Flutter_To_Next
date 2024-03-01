import 'package:flutter/material.dart';

class MsgCardsForPhone extends StatelessWidget {
  const MsgCardsForPhone({
    Key? key,
    required this.itemCount,
    required this.child
  }) : super(key: key);
  final int itemCount;
  final Widget Function(int) child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
      padding:
          const EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 16),
      child: GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            mainAxisExtent: 150,
          ),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, index) {
            return child(index);
          }),
    );
  }
}