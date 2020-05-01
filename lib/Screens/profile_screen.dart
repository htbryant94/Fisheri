import 'package:fisheri/Screens/auth_screen.dart';
import 'package:fisheri/Screens/events_calendar_screen.dart';
import 'package:fisheri/Screens/create_event_screen.dart';
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
    this.navBarIcon,
});

  final String title;
  final Icon icon;
  final Widget screen;
  final Widget navBarIcon;
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
        screen: FishingLicenseScreen(),
        title: "Fishing License - WIP",
        icon: Icon(Icons.description),
      ),
      ProfileListItem(
        screen: EventsCalendarScreen(),
        title: "Events - WIP",
        icon: Icon(Icons.calendar_today),
        navBarIcon: CupertinoButton(
          padding: EdgeInsets.only(bottom: 8, top: 8),
          child: Icon(Icons.add),
          onPressed: () {
            Coordinator.push(
              context,
              currentPageTitle: 'Profile',
              screen: CreateEventScreen(),
              screenTitle: 'Create Event'
            );
          },
        )
      ),
      ProfileListItem(
        screen: null,
        title: "Saved Venues",
        icon: Icon(Icons.backup),
      ),
      ProfileListItem(
        screen: null,
        title: "Settings",
        icon: Icon(Icons.settings),
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
                    screen: item.screen,
                    navBarIcon: item.navBarIcon,
                );
              } : null,
            );
          },
        ),
      ),
    );
  }
}