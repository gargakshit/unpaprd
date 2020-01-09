import 'package:flutter/material.dart';
import 'package:unpaprd/screens/player.dart';
import 'package:unpaprd/screens/search.dart';

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
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) => setState(() => idx = i),
        elevation: 0,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text("Explore"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            title: Text("Player"),
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
