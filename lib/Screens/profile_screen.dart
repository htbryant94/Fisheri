import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisheri/Screens/achievements_screen.dart';
import 'package:fisheri/Screens/auth_screen.dart';
import 'package:fisheri/Screens/events_calendar_screen.dart';
import 'package:fisheri/Screens/create_event_screen.dart';
import 'package:fisheri/Screens/fishing_license_screen.dart';
import 'package:fisheri/Screens/search_results_screen.dart';
import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileListItem {
  ProfileListItem({
    this.title,
    this.icon,
    this.screen,
    this.navBarIcon,
    this.action,
});

  final String title;
  final Icon icon;
  final Widget screen;
  final VoidCallback action;
  final Widget navBarIcon;
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = _auth.currentUser != null;

    final items = [
      ProfileListItem(
          screen: VenueFormScreen(),
          title: 'Add a Venue',
          icon: Icon(Icons.add, color: Colors.green)
      ),
      ProfileListItem(
          screen: AllVenuesListBuilder(),
          title: 'Edit a Venue',
          icon: Icon(Icons.library_books, color: Colors.green)
      ),
      ProfileListItem(
        screen: FishingLicenseScreen(),
        title: 'Fishing License - PoC',
        icon: Icon(Icons.description, color: Colors.green),
      ),
      ProfileListItem(
        screen: AchievementsScreen(),
        title: 'Achievements - PoC',
        icon: Icon(Icons.whatshot, color: Colors.orange)
      ),
      ProfileListItem(
        screen: EventsCalendarScreen(),
        title: 'Events - PoC',
        icon: Icon(Icons.calendar_today, color: Colors.red[600]),
        navBarIcon: CupertinoButton(
          padding: EdgeInsets.only(bottom: 8, top: 8),
          child: Icon(Icons.add),
          onPressed: () {
            Coordinator.present(
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
        title: 'My Favourites',
        icon: Icon(Icons.favorite, color: Colors.pink),
      ),
      ProfileListItem(
          screen: null,
          title: 'Contact Us',
          icon: Icon(Icons.phone, color: Colors.blue)
      ),
      ProfileListItem(
        screen: null,
        title: 'Settings',
        icon: Icon(Icons.settings, color: Colors.blueGrey),
      ),
      if (_isLoggedIn)
      ProfileListItem(
        title: 'Sign out',
        icon: Icon(Icons.logout),
        action: () {
          _auth.signOut().whenComplete(() {
            setState(() {
              _isLoggedIn = false;
            });
          });
        },
      ),
      if (!_isLoggedIn)
      ProfileListItem(
        icon: Icon(Icons.account_circle, color: Colors.blue),
        title: 'Sign in',
        action: () {
          Coordinator.present(
            context,
            screenTitle: 'Sign in',
            screen: AuthScreen()
          );
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 24),
            itemCount: items.length,
            separatorBuilder: (context, index) {
              return Divider(indent: 40);
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                  title: DSComponents.body(text: item.title),
                  leading: item.icon,
                  onTap: _getAction(context, item)
              );
          },
        ),
      ),
    );
  }

  VoidCallback _getAction(BuildContext context, ProfileListItem item) {
    if (item.screen != null) {
      return () {
        Coordinator.present(
          context,
          currentPageTitle: 'Profile',
          screenTitle: item.title,
          screen: item.screen,
          navBarIcon: item.navBarIcon,
        );
      };
    } else if (item.action != null) {
      return item.action;
    }
    return null;
  }
}