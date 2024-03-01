import 'package:flutter/material.dart';
import 'package:kirihare/common/assets.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key
  }) : super(key: key);
  @override 
  Widget build(BuildContext context) {
    return IconButton(
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(
          context, '/LoginPage', (route) => false);
    },
    icon: Image.asset(Assets.IC_LOGIN));
  }
}