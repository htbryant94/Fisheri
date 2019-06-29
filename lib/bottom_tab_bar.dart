import 'package:flutter/material.dart';
import 'house_colors.dart';

class BottomTabBar extends StatefulWidget {
  BottomTabBar(this.selectedIndex);

  final int selectedIndex;

  @override
  State<StatefulWidget> createState() {
    return _BottomTabBarState(selectedIndex);
  }
}

class _BottomTabBarState extends State<BottomTabBar> {
  _BottomTabBarState(this.selectedIndex);

  int selectedIndex;

  void _incrementTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.shifting,
      backgroundColor: HouseColors.primaryGreen,
      items: [
        BottomNavigationBarItem(
            activeIcon: Icon(Icons.explore),
            backgroundColor: HouseColors.primaryGreen,
            icon: Icon(Icons.explore, color: HouseColors.white),
            title: Text(
              'Login',
              style: TextStyle(color: HouseColors.white),
            )),
        BottomNavigationBarItem(
            activeIcon: Icon(Icons.search),
            backgroundColor: HouseColors.primaryGreen,
            icon: Icon(Icons.search, color: HouseColors.white),
            title: Text(
              'Search',
              style: TextStyle(color: HouseColors.white),
            )),
        BottomNavigationBarItem(
            backgroundColor: HouseColors.primaryGreen,
            icon: Icon(Icons.star, color: HouseColors.white),
            title: Text(
              'Results',
              style: TextStyle(color: HouseColors.white),
            )),
        BottomNavigationBarItem(
            backgroundColor: HouseColors.primaryGreen,
            icon: Icon(Icons.account_circle, color: HouseColors.white),
            title: Text(
              'Venue',
              style: TextStyle(color: HouseColors.white),
            ))
      ],
      onTap: (index) {
        _incrementTab(index);
      },
    );
  }
}
