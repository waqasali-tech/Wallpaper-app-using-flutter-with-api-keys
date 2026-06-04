import 'package:final_project/login/authroize.dart';
import 'package:final_project/pages/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

class LightDark extends StatefulWidget {
  const LightDark({super.key});

  @override
  State<LightDark> createState() => _LightDarkState();
}

class _LightDarkState extends State<LightDark>with TickerProviderStateMixin {
  
  

  bool isDarkModeEnabled = false;

  


  void onStateChanged(bool newValue) {
    setState(() {
      isDarkModeEnabled = newValue;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Authorize()),
    );
  }
  

  @override

  Widget build(BuildContext context) {
    final ThemeData theme = isDarkModeEnabled
        ? ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            scaffoldBackgroundColor: Colors.black,
          )
        : ThemeData.light();

    return Theme(
      data: theme,
      child: Scaffold(
       drawer: Drawer(
  child: Container(
    color: isDarkModeEnabled ? Colors.black : Colors.white,
    child: Center(
      child: IconButton(
        onPressed: signUserOut,
        icon: Icon(
          Icons.logout,
          color: isDarkModeEnabled ? Colors.white : Colors.black,
          size: 30,
        ),
      ),
    ),
  ),
),

appBar: AppBar(
  backgroundColor: Colors.blue,
  title: Text(
    "My Wallpaper",
    style: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: Colors.deepOrange,
      shadows: [
        Shadow(
          offset: Offset(2, 2),
          blurRadius: 4,
          color: Colors.black45,
        ),
      ],
    ),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 10, left: 15),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 4000),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: animation,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(isDarkModeEnabled),
          child: DayNightSwitcherIcon(
            isDarkModeEnabled: isDarkModeEnabled,
            onStateChanged: onStateChanged,
          ),
        ),
      ),
    )
  ],
),
body: const BottomNav(),
),
);
  }
}
  