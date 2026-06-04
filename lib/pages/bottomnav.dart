import 'package:final_project/pages/categories.dart';

import 'package:final_project/pages/home.dart';
import 'package:final_project/pages/livewallpaper.dart';
import 'package:final_project/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

@override
   State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
    int currentTabIndex = 0;
   late List<Widget> pages;
   late Home home;
  late Search search;
      late Categories categories;
  late LiveWallpaperScreen liveWallpaper;

  @override
  void initState() {
    home =  const  Home();
    search =  Search();
    categories =  Categories();
    liveWallpaper = LiveWallpaperScreen();
    pages = [home, search, categories, liveWallpaper];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: IndexedStack(
  index: currentTabIndex,
  children: pages,
),

               bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        buttonBackgroundColor: Colors.black,
                backgroundColor: Colors.white,
        color: Colors.blue,
            //color: const Color.fromRGBO(13, 71, 161, 1),
       // color: Color.fromRGBO(85, 87, 93, 1), // You can adjust this color
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.search_outlined, color: Colors.white),
      Icon(Icons.category_outlined, color: Colors.white),
          Icon(Icons.dynamic_feed, color: Colors.white,)
        ],
      ),
    );
  }
}
