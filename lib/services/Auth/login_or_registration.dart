import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/registration_page.dart';
import 'package:flutter/material.dart';

class login_or_register extends StatefulWidget {
  const login_or_register({super.key});

  @override
  State<login_or_register> createState() => _login_or_registerState();
}

class _login_or_registerState extends State<login_or_register> {
  bool showloginpage = true;
  void togglepages() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return Login_page(
        onTap: togglepages,
      );
    } else {
      return register_page(
        onTap: togglepages,
      );
    }
  }
}
