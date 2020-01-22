import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:unpaprd/screens/player.dart';
import 'package:unpaprd/screens/search.dart';
import 'package:unpaprd/screens/settings.dart';

import 'explore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExplorePage(
        navigate: () => setState(() => idx = 2),
      ),
      SearchPage(
        navigate: () => setState(() => idx = 2),
      ),
      PlayerPage(),
      SettingsPage(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) => setState(() => idx = i),
        elevation: 0,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Feather.compass),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.search),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.play),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.settings),
            title: Container(),
          ),
        ],
      ),
      body: IndexedStack(
        children: pages,
        index: idx,
      ),
    );
  }
}
