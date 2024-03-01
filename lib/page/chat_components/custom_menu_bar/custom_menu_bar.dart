import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  const CustomMenuBar({
    Key? key,
    required this.showMenuBar,
    required this.showMenu,
    required this.onKeyBoardPressed,
    required this.toggleShowMenu
  }) : super(key: key);
  final bool showMenuBar;
  final bool showMenu;
  final void Function()? onKeyBoardPressed;
  final void Function()? toggleShowMenu;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showMenuBar,
      child: Container(
        padding: EdgeInsets.only(
            left: 10, bottom: 3, top: 3, right: 10),
        decoration: BoxDecoration(color: Colors.black87),
        child: Row(
          children: [
            IconButton(
                onPressed: onKeyBoardPressed,
                icon: Icon(
                  Icons.keyboard,
                  color: Colors.white,
                )),
            Spacer(),
            InkWell(
              onTap: toggleShowMenu,
              child: Container(
                padding: EdgeInsets.only(
                    left: 80,
                    right: 80,
                    top: 10,
                    bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'メニュー',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    showMenu
                        ? Icon(Icons.arrow_drop_down,
                            size: 18, color: Colors.white)
                        : Icon(
                            Icons.arrow_drop_up_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                  ],
                ),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}