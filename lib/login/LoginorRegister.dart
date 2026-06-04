import 'package:final_project/login/Registerpage.dart';
import 'package:final_project/login/page_login.dart';
//import 'package:final_project/login/register_page.dart';
import 'package:flutter/material.dart';

class Loginorregister extends StatefulWidget {
  const Loginorregister({super.key});

  @override
  State<Loginorregister> createState() => _LoginorregisterState();
}

class _LoginorregisterState extends State<Loginorregister> {
  bool showLogin = true;

  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return Login(
        onTap: togglePages, // ✅ Fixed: semicolon removed, function passed
      );
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
