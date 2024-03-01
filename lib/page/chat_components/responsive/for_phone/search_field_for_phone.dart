import 'package:flutter/material.dart';

class SearchFieldForPhone extends StatelessWidget {
  const SearchFieldForPhone({
    Key? key,
    required this.isSearch,
    required this.onClearButtonPressed,
    required this.searchFocusNode,
    required this.onSubmitted,
    required this.onChanged
  }) : super(key: key);
  final bool isSearch;
  final void Function()? onClearButtonPressed;
  final FocusNode searchFocusNode;
  final ValueChanged<String>?  onSubmitted;
  final ValueChanged<String>?  onChanged;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isSearch,
      child: TextField(
        textInputAction: TextInputAction.done,
        focusNode: searchFocusNode,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: onClearButtonPressed,
              child:
                  Icon(Icons.clear, color: Colors.white)),
          suffixIconConstraints:
              BoxConstraints(minWidth: 40, minHeight: 40),
          isDense: true,
          contentPadding: EdgeInsets.only(
              left: 10, right: 10, top: 5, bottom: 5),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: Colors.white)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30)
          )
        ),
      ),
    );
  }
}