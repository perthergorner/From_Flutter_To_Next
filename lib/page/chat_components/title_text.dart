import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({Key? key,required this.isSearch}) : super(key: key);
  final bool isSearch;
  @override
  Widget build(BuildContext context) {
    return Visibility(visible: !isSearch, child: Text('  KIRIHARE'));
  }
}