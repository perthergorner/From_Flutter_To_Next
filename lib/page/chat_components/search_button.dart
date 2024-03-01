import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
    required this.isSearch,
    required this.onSearchButtonPressed
  }) : super(key: key);
  final bool isSearch;
  final void Function() onSearchButtonPressed;
  @override 
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isSearch,
      child: IconButton(
        onPressed: onSearchButtonPressed,
        icon: Icon(Icons.search)
      )
    );
  }
}