import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

import 'package:fisheri/house_texts.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/Screens/webview_screen.dart';

class SocialMediaSection extends StatelessWidget {
  SocialMediaSection({this.social});

  final Social social;
  final double scale = 40;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          HouseTexts.heading('Social Links'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (social.facebook != null && social.facebook.isNotEmpty)
              SocialMediaIcon(
                socialMedia: SocialMedia.facebook,
                url: social.facebook,
                scale: scale,
              ),
              if (social.instagram != null && social.instagram.isNotEmpty)
              SocialMediaIcon(
                socialMedia: SocialMedia.instagram,
                url: social.instagram,
                scale: scale,
              ),
              if (social.twitter != null && social.twitter.isNotEmpty)
              SocialMediaIcon(
                socialMedia: SocialMedia.twitter,
                url: social.twitter,
                scale: scale,
              ),
              if (social.youtube != null && social.youtube.isNotEmpty)
              SocialMediaIcon(
                socialMedia: SocialMedia.youtube,
                url: social.youtube,
                scale: scale,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum SocialMedia {
  facebook,
  instagram,
  twitter,
  youtube
}

class SocialMediaIcon extends StatelessWidget {
  SocialMediaIcon({
    this.socialMedia,
    this.url,
    this.scale,
  });

  final SocialMedia socialMedia;
  final String url;
  final double scale;

  @override
  Widget build(BuildContext context) {

    String urlPrefix(SocialMedia socialMedia) {
      switch (socialMedia) {
        case SocialMedia.facebook: {
          return 'facebook.com';
        }
        case SocialMedia.instagram: {
          return 'instagram.com';
        }
        case SocialMedia.twitter: {
          return 'twitter.com';
        }
        case SocialMedia.youtube: {
          return 'youtube.com';
        }
      }
      return null;
    }

    String buildURL(String prefix, String url) {
      if (prefix != null) {
        return 'https://www.$prefix/$url/';
      }
      return null;
    }

    return Opacity(
        opacity: url != null ? 1 : 0.3,
        child: GestureDetector(
          onTap: url != null ? () {
            final String formattedURL = buildURL(urlPrefix(socialMedia), url);
            if (formattedURL != null) {
              Coordinator.push(
                context,
                screen: WebViewExplorer(url: formattedURL),
                screenTitle: StringUtils.capitalize(describeEnum(socialMedia)),
                currentPageTitle: 'Fisheri',
              );
            }
          } : null,
          child: Image.asset(
              'images/icons/social_media/${describeEnum(socialMedia)}.png',
              width: scale,
              height: scale
          ),
        )
    );
  }
}