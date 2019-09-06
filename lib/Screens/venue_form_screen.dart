import 'package:fisheri/house_colors.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class VenueFormScreen extends StatefulWidget {
  VenueFormScreen();

  @override
  _VenueFormScreenState createState() => _VenueFormScreenState();
}

class _VenueFormScreenState extends State<VenueFormScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
      children: <Widget>[
        Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  _OverviewSection(),
                  _AddressSection(),
                  _AmenitiesSection(),
                  _ContactDetailsSection(),
                  _SocialLinksSection(),
                  _FishStockedSection(),
                  _FishingTypesSection(),
                  _TicketsSection(),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                MaterialButton(
                  child: Text("Submit"),
                  onPressed: () {

                    Function _valueFor = ({String attribute}) {
                      return _fbKey.currentState.fields[attribute].currentState.value;
                    };

                    final _venue = VenueDetailed(
                      name: _valueFor(attribute: 'name'),
                      isLake: _valueFor(attribute: 'venue_type').toString().contains('Lake'),
                      isShop: _valueFor(attribute: 'venue_type').toString().contains('Shop'),
                      description: _valueFor(attribute: 'description'),
                      address: VenueAddress(
                        street: _valueFor(attribute: 'address_street'),
                        town: _valueFor(attribute: 'address_town'),
                        county: _valueFor(attribute: 'address_county'),
                        postcode: _valueFor(attribute: 'postcode'),
                      ),
                      amenities: _valueFor(attribute: 'amenities'),
                      contactDetails: ContactDetails(
                        email: _valueFor(attribute: 'contact_email'),
                        phone: _valueFor(attribute: 'contact_phone'),
                      ),
                      social: Social(
                        facebook: _valueFor(attribute: 'social_facebook'),
                        instagram: _valueFor(attribute: 'social_instagram'),
                        twitter: _valueFor(attribute: 'social_twitter'),
                        youtube: _valueFor(attribute: 'social_youtube'),
                      ),
                      fishStocked: _valueFor(attribute: 'fish_stocked'),
                      fishingTypes: _valueFor(attribute: 'fishing_types'),
                      tickets: _valueFor(attribute: 'tickets'),
                    );
                    print(_venue.isLake);
                    if (_fbKey.currentState.saveAndValidate()) {
                      print(_fbKey.currentState.value);
                    }
                  },
                ),
                MaterialButton(
                  child: Text("Reset"),
                  onPressed: () {
                    _fbKey.currentState.reset();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  _Header(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Add a Venue'),
        FormBuilderTextField(
          attribute: "name",
          decoration: InputDecoration(labelText: "Name of Venue *"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(50),
          ],
        ),
        FormBuilderCheckboxList(
          decoration: InputDecoration(labelText: "Venue Type *"),
          activeColor: HouseColors.accentGreen,
          checkColor: HouseColors.primaryGreen,
          attribute: "venue_type",
          options: [
            FormBuilderFieldOption(value: "Lake"),
            FormBuilderFieldOption(value: "Shop"),
          ],
        ),
        FormBuilderTextField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: null,
          attribute: "description",
          decoration: InputDecoration(
              labelText: "Description",
              helperText:
                  "Include pricing information or details on how to get to your venue here",
              border: OutlineInputBorder()),
          validators: [
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(1000),
          ],
        ),
      ],
    );
  }
}

class _AddressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Address'),
        FormBuilderTextField(
          attribute: "address_street",
          decoration: InputDecoration(labelText: "Street *"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(100),
          ],
        ),
        FormBuilderTextField(
          attribute: "address_town",
          decoration: InputDecoration(labelText: "Town *"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(100),
          ],
        ),
        FormBuilderTextField(
          attribute: "address_county",
          decoration: InputDecoration(labelText: "County *"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(100),
          ],
        ),
        FormBuilderTextField(
          attribute: "address_postcode",
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: "Postcode *"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(6),
            FormBuilderValidators.maxLength(8),
          ],
        ),
      ],
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Amenities'),
        FormBuilderTextField(
          attribute: "amenities_num_lakes",
          decoration: InputDecoration(labelText: "Number of Lakes"),
          validators: [FormBuilderValidators.numeric()],
        ),
        FormBuilderCheckboxList(
          attribute: "amenities_list",
          options: [
            FormBuilderFieldOption(value: "Toilets"),
            FormBuilderFieldOption(value: "Showers"),
            FormBuilderFieldOption(value: "Food & Drink"),
            FormBuilderFieldOption(value: "Night Fishing"),
            FormBuilderFieldOption(value: "Wheelchair Access"),
            FormBuilderFieldOption(value: "Guests Allowed"),
            FormBuilderFieldOption(value: "Trolley Hire"),
            FormBuilderFieldOption(value: "Takeaway Friendly"),
            FormBuilderFieldOption(value: "Animal Friendly"),
            FormBuilderFieldOption(value: "Tuition"),
            FormBuilderFieldOption(value: "Electricity"),
            FormBuilderFieldOption(value: "Equipment Hire"),
            FormBuilderFieldOption(value: "Wifi"),
            FormBuilderFieldOption(value: "Camping"),
          ],
        ),
      ],
    );
  }
}

class _ContactDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Venue Contact Details'),
        FormBuilderTextField(
          attribute: "contact_email",
          decoration: InputDecoration(
            labelText: "Email",
            icon: Icon(Icons.email),
          ),
          validators: [
            FormBuilderValidators.email(),
          ],
        ),
        FormBuilderTextField(
          attribute: "contact_phone",
          decoration: InputDecoration(
            labelText: "Phone",
            icon: Icon(Icons.phone),
          ),
          validators: [
            // TODO: Add validation for phone number
          ],
        ),
        FormBuilderTextField(
          attribute: "contact_url",
          decoration: InputDecoration(
            labelText: "Website URL",
            icon: Icon(Icons.language),
            hintText: "https://www.add_this_part_here",
          ),
          validators: [
            FormBuilderValidators.url(),
          ],
        ),
      ],
    );
  }
}

class _SocialLinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Social Links'),
        FormBuilderTextField(
          attribute: "social_facebook",
          decoration: InputDecoration(
            labelText: "Facebook",
            helperText: "www.facebook.com/your_page_here",
          ),
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "social_instagram",
          decoration: InputDecoration(
            labelText: "Instagram",
            helperText: "@your_handle_here",
          ),
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "social_twitter",
          decoration: InputDecoration(labelText: "Twitter"),
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "social_youtube",
          decoration: InputDecoration(labelText: "Youtube"),
          validators: [],
        ),
      ],
    );
  }
}

class _FishStockedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Fish Stocked'),
        FormBuilderCheckboxList(
          attribute: "fish_stocked",
          options: [
            FormBuilderFieldOption(value: "Crucian Carp"),
            FormBuilderFieldOption(value: "Chub"),
            FormBuilderFieldOption(value: "Roach"),
            FormBuilderFieldOption(value: "Grass Carp"),
            FormBuilderFieldOption(value: "Perch"),
            FormBuilderFieldOption(value: "Rudd"),
            FormBuilderFieldOption(value: "Rainbow Trout"),
            FormBuilderFieldOption(value: "Brown Trout"),
            FormBuilderFieldOption(value: "Salmon"),
            FormBuilderFieldOption(value: "Koi Carp"),
            FormBuilderFieldOption(value: "Grayling"),
            FormBuilderFieldOption(value: "Zander"),
            FormBuilderFieldOption(value: "Eel"),
            FormBuilderFieldOption(value: "Orfe"),
            FormBuilderFieldOption(value: "Dace"),
            FormBuilderFieldOption(value: "Gudgeon"),
            FormBuilderFieldOption(value: "Ruffe"),
          ],
        ),
      ],
    );
  }
}

class _FishingTypesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Fishing Types'),
        FormBuilderCheckboxList(
          attribute: "fishing_types",
          options: [
            FormBuilderFieldOption(value: "Coarse"),
            FormBuilderFieldOption(value: "Match"),
            FormBuilderFieldOption(value: "Fly"),
            FormBuilderFieldOption(value: "Carp"),
            FormBuilderFieldOption(value: "Catfish"),
          ],
        ),
      ],
    );
  }
}

class _TicketsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Header('Tickets Available'),
        FormBuilderCheckboxList(
          attribute: "tickets",
          options: [
            FormBuilderFieldOption(value: "Day"),
            FormBuilderFieldOption(value: "Night"),
            FormBuilderFieldOption(value: "Season"),
            FormBuilderFieldOption(value: "Syndicate"),
            FormBuilderFieldOption(value: "Club Water"),
          ],
        ),
      ],
    );
  }
}

//class VenueFormScreen extends StatefulWidget {
//  @override
//  _VenueFormScreenState createState() => _VenueFormScreenState();
//}
//
//class _VenueFormScreenState extends State<VenueFormScreen> {
//  final _formKey = GlobalKey<FormState>();
//
//  @override
//  Widget build(BuildContext context) {
//    return Form(
//      key: _formKey,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          _VenueNameTextFormField(),
////          TextFormField(
////            decoration: const InputDecoration(
////              labelText: 'Name of Venue',
////            ),
////            validator: (value) {
////              if (value.isEmpty) {
////                return 'Please enter some text';
////              }
////              return null;
////            },
////          ),
//          TextFormField(
//            validator: (value) {
//              if (value.isEmpty) {
//                return 'Please enter a number between 1 - 100';
//              }
//              return null;
//            },
//          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(vertical: 16.0),
//            child: RaisedButton(
//              onPressed: () {
//                if (_formKey.currentState.validate()) {
//                  print('success!!');
//                }
//              },
//              child: Text('Submit'),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
//
//class _TextFormFieldBuilder extends StatelessWidget {
//  _TextFormFieldBuilder({this.title, this.validator});
//
//  final String title;
//  final FormFieldValidator<String> validator;
//
//  @override
//  Widget build(BuildContext context) {
//    return TextFormField(
//      decoration: InputDecoration(
//        labelText: title,
//      ),
//      validator: validator,
//    );
//  }
//}
//
//class _VenueNameTextFormField extends StatelessWidget {
//  _VenueNameTextFormField();
//
//  @override
//  Widget build(BuildContext context) {
//    String _validator(String value) {
//      if (value.length <= 4) {
//        return 'Mandatory field: entry must be longer than 4 characters';
//      }
//      return null;
//    }
//
//    return _TextFormFieldBuilder(
//      title: 'Name of Venue',
//      validator: _validator,
//    );
//  }
//}
