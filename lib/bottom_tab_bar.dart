import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'house_colors.dart';

class BottomTabs extends StatelessWidget {
  BottomTabs({
    Key key,
    this.selectedTab,
    this.onTap,
  }) : super(key: key);

  final int selectedTab;
  final ValueChanged<int> onTap;

  BottomNavigationBarItem _tabItem(Icon icon, String title) {
    return BottomNavigationBarItem(
      backgroundColor: HouseColors.primaryGreen,
      icon: icon,
      title: Text('$title', style: TextStyle(fontSize: 12))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FisheriBottomBar(
        currentIndex: selectedTab,
        onTap: onTap,
        items: [
          _tabItem(Icon(Icons.explore), 'Login'),
          _tabItem(Icon(Icons.search), 'Search'),
          _tabItem(Icon(Icons.star), 'Results'),
          _tabItem(Icon(Icons.account_circle), 'Venue')
        ],
      ),
    );
  }
}

class FisheriBottomBar extends StatelessWidget {
  FisheriBottomBar({
    Key key,
    this.currentIndex,
    this.onTap,
    this.items,
  }) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      backgroundColor: HouseColors.primaryGreen,
      inactiveColor: Colors.white30,
      activeColor: HouseColors.accentGreen,
      iconSize: 22,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}