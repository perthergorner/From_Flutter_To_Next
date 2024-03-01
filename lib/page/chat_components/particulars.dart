import 'package:flutter/material.dart';
import 'package:kirihare/common/shadow.dart';

class Particulars extends StatelessWidget {
  const Particulars({
    Key? key,
    required this.text,
    required this.child
  }) : super(key: key);
  final String text;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.22,
      height: size.height * 0.60,
      decoration: BoxDecoration(
        boxShadow: basicShadow
      ),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ),
              Container(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}