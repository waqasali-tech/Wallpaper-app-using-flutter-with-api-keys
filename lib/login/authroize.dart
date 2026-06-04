import 'package:final_project/Splash/splashscreen.dart';
import 'package:final_project/login/LoginorRegister.dart';
//import 'package:final_project/login/login_or_register.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authorize extends StatelessWidget {
  const Authorize({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const  SplashToMain();
          } else {
            return Loginorregister();
          }
        },
        
      ),
    );
  }
}
