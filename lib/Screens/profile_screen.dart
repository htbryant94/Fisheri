import 'package:fisheri/Screens/auth_screen.dart';
import 'package:fisheri/Screens/fishing_license_screen.dart';
import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/house_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileListItem {
  ProfileListItem({
    this.title,
    this.icon,
    this.screen,
});

  final String title;
  final Icon icon;
  final Widget screen;
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final List<ProfileListItem> items = [
      ProfileListItem(
          screen: VenueFormScreen(),
          title: "Add a Venue",
          icon: Icon(Icons.add)
      ),
      ProfileListItem(
          screen: AuthScreen(),
          title: "Login",
          icon: Icon(Icons.account_circle)
      ),
      ProfileListItem(
        screen: null,
        title: "Settings",
        icon: Icon(Icons.settings),
      ),
      ProfileListItem(
        screen: FishingLicenseScreen(),
        title: "Fishing License",
        icon: Icon(Icons.description),
      ),
      ProfileListItem(
        screen: null,
        title: "Events",
        icon: Icon(Icons.calendar_today),
      ),
      ProfileListItem(
        screen: null,
        title: "Saved Venues",
        icon: Icon(Icons.backup),
      ),
    ];

    return Scaffold(
      body: SafeArea(
          child: ListView.separated(
            itemCount: items.length,

            separatorBuilder: (context, index) {
              return Divider(indent: 40);
            },
            itemBuilder: (context, index) {
              final item = items[index];
            return ListTile(
              title: HouseTexts.subheading(item.title),
              leading: item.icon,
              onTap: item.screen != null ? () {
                Coordinator.push(
                    context,
                    currentPageTitle: 'Profile',
                    screenTitle: item.title,
                    screen: item.screen);
              } : null,
            );
          },
        ),
      ),
    );
  }
}