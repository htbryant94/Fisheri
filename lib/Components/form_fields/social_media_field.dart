import 'package:fisheri/house_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SocialMediaField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseTexts.subtitle('Social Links'),
        FormBuilderTextField(
          name: "social_facebook",
          decoration: InputDecoration(
            labelText: "Facebook",
            helperText: "e.g. www.facebook.com/fisheri_uk",
            prefixText: "www.facebook.com/",
          ),
          maxLines: 1,
        ),
        FormBuilderTextField(
          name: "social_instagram",
          decoration: InputDecoration(
            labelText: "Instagram",
            helperText: "e.g. @fisheriUK",
            prefixText: "@",
          ),
          maxLines: 1,
        ),
        FormBuilderTextField(
          name: "social_twitter",
          decoration: InputDecoration(
            labelText: "Twitter",
            helperText: "e.g. @fisheriUK",
            prefixText: "@",
          ),
          maxLines: 1,
        ),
        FormBuilderTextField(
          name: "social_youtube",
          decoration: InputDecoration(
              labelText: "Youtube",
              helperText: "e.g. www.youtube.com/user/fisheriUK",
              prefixText: "www.youtube.com/user/"
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}