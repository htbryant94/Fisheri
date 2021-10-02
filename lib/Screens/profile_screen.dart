// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisheri/Screens/auth_screen.dart';
import 'package:fisheri/Screens/search_results_screen.dart';
import 'package:fisheri/Screens/venue_form_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
import 'package:fisheri/models/fisheri_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileListItem {
  ProfileListItem({
    this.title,
    this.subtitle,
    this.icon,
    this.screen,
    this.navBarIcon,
    this.action,
});

  final String title;
  final String subtitle;
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
  final _adminUsers = [
    'YB5taOmJkkS2yE7CQZd2Y1r3ohP2',
    'Px6LdKOFy4RIImBg18Jvho5hYy93',
    'CD0fIQ4BozOoYxBktmSBev5qiQh2'
  ];

  final _initialImages = [
    FisheriImage(id: '520ce9f0-1ed8-11ec-ada9-576c0d07763f', url: 'https://firebasestorage.googleapis.com:443/v0/b/fishing-finder-594f0.appspot.com/o/test%2F520ce9f0-1ed8-11ec-ada9-576c0d07763f?alt=media&token=8eb8ad6b-1221-4318-a904-e17e6aced4e3'),
    FisheriImage(id: '4430d100-1ed5-11ec-ada9-576c0d07763f', url: 'https://firebasestorage.googleapis.com:443/v0/b/fishing-finder-594f0.appspot.com/o/test%2F4430d100-1ed5-11ec-ada9-576c0d07763f?alt=media&token=87e13b3b-ef47-47f5-a485-3c79adaf8ed0'),
    FisheriImage(id: '492b13f0-1ed5-11ec-ada9-576c0d07763f', url: 'https://firebasestorage.googleapis.com:443/v0/b/fishing-finder-594f0.appspot.com/o/test%2F492b13f0-1ed5-11ec-ada9-576c0d07763f?alt=media&token=22353675-0ce7-44df-ab7a-7fcace58005a'),
  ];

  @override
  Widget build(BuildContext context) {
    var _isLoggedIn = _auth.currentUser != null;

    bool _isAdminUser() {
      if (_isLoggedIn) {
        return _adminUsers.contains(_auth.currentUser.uid);
      }
        return false;
    }

    final items = [
      if (_isLoggedIn && _isAdminUser())
      ProfileListItem(
          screen: VenueFormScreen(),
          title: 'Add a Venue',
          icon: Icon(Icons.add, color: Colors.green)
      ),
      if (_isLoggedIn && _isAdminUser())
        ProfileListItem(
          screen: AllVenuesListBuilder(),
          title: 'Edit a Venue',
          icon: Icon(Icons.library_books, color: Colors.green)
      ),
      // ProfileListItem(
      //   screen: FishingLicenseScreen(),
      //   title: 'Fishing License - PoC',
      //   icon: Icon(Icons.description, color: Colors.green),
      // ),
      // ProfileListItem(
      //   screen: AchievementsScreen(),
      //   title: 'Achievements - PoC',
      //   icon: Icon(Icons.whatshot, color: Colors.orange)
      // ),
      // ProfileListItem(
      //   screen: EventsCalendarScreen(),
      //   title: 'Events - PoC',
      //   icon: Icon(Icons.calendar_today, color: Colors.red[600]),
      //   navBarIcon: CupertinoButton(
      //     padding: EdgeInsets.only(bottom: 8, top: 8),
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       Coordinator.present(
      //         context,
      //         currentPageTitle: 'Profile',
      //         screen: CreateEventScreen(),
      //         screenTitle: 'Create Event'
      //       );
      //     },
      //   )
      // ),
      // ProfileListItem(
      //   screen: null,
      //   title: 'My Favourites',
      //   icon: Icon(Icons.favorite, color: Colors.pink),
      // ),
      // ProfileListItem(
      //     screen: null,
      //     title: 'Contact Us',
      //     icon: Icon(Icons.phone, color: Colors.blue)
      // ),
      // ProfileListItem(
      //   screen: null,
      //   title: 'Settings',
      //   icon: Icon(Icons.settings, color: Colors.blueGrey),
      // ),
      if (_isLoggedIn)
      ProfileListItem(
        title: 'Sign out',
        subtitle: _auth.currentUser.email,
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
        title: 'Sign in / Register',
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
                  subtitle: item.subtitle != null ? DSComponents.body(text: item.subtitle) : null,
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