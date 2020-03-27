import 'package:fisheri/house_colors.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/opening_hours_list.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:fisheri/house_texts.dart';

class VenueDetailedConstants {
  static const String name = "name";
  static const String isLake = "is_lake";
  static const String isShop = "is_shop";
  static const String address = "address";
  static const String amenities = "amenities_array";
  static const String assetsPath = "assets_path";
  static const String contactDetails = "contact_details";
  static const String coordinates = "coordinates";
  static const String description = "description";
  static const String fishStocked = "fish_stock_array";
  static const String fishingTypes = "fishing_types_array";
  static const String hoursOfOperation = "hours_of_operation";
  static const String social = "social";
  static const String tickets = "tickets_array";
}

class VenueFormScreen extends StatefulWidget {
  VenueFormScreen();

  @override
  _VenueFormScreenState createState() => _VenueFormScreenState();
}

class _VenueFormScreenState extends State<VenueFormScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                      SizedBox(height: 16),
                      _CoordinatesSection(),
                      SizedBox(height: 16),
                      _AddressSection(),
                      SizedBox(height: 16),
                      _AmenitiesSection(),
                      SizedBox(height: 16),
                      _ContactDetailsSection(),
                      SizedBox(height: 16),
                      _SocialLinksSection(),
                      SizedBox(height: 16),
                      _FishStockedSection(),
                      SizedBox(height: 16),
                      _FishingTypesSection(),
                      SizedBox(height: 16),
                      _TicketsSection(),
                      SizedBox(height: 16),
                      _FishingRulesSection(),
                      SizedBox(height: 16),
                      _OperationalHoursSection(),
                      
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                        child: Text("Submit"),
                        onPressed: () {
                          Function _valueFor = ({String attribute}) {
                            return _fbKey
                                .currentState.fields[attribute].currentState.value;
                          };

                          HoursOfOperation operationalHours = HoursOfOperation(
                            monday: OpeningHoursDay(
                              open: _valueFor(attribute: 'monday_open'),
                              close: _valueFor(attribute: 'monday_close'),
                            ),
                            tuesday: OpeningHoursDay(
                              open: _valueFor(attribute: 'tuesday_open'),
                              close: _valueFor(attribute: 'tuesday_close'),
                            ),
                            wednesday: OpeningHoursDay(
                              open: _valueFor(attribute: 'wednesday_open'),
                              close: _valueFor(attribute: 'wednesday_close'),
                            ),
                            thursday: OpeningHoursDay(
                              open: _valueFor(attribute: 'thursday_open'),
                              close: _valueFor(attribute: 'thursday_close'),
                            ),
                            friday: OpeningHoursDay(
                              open: _valueFor(attribute: 'friday_open'),
                              close: _valueFor(attribute: 'friday_close'),
                            ),
                            saturday: OpeningHoursDay(
                              open: _valueFor(attribute: 'saturday_open'),
                              close: _valueFor(attribute: 'saturday_close'),
                            ),
                            sunday: OpeningHoursDay(
                              open: _valueFor(attribute: 'sunday_open'),
                              close: _valueFor(attribute: 'sunday_close'),
                            ),
                          );
                          final _venue = VenueDetailed(
                            name: _valueFor(attribute: VenueDetailedConstants.name),
                            isShop: _valueFor(attribute: 'venue_type')
                                .toString()
                                .contains('Shop'),
                            isLake: _valueFor(attribute: 'venue_type')
                                .toString()
                                .contains('Lake'),
                            description: _valueFor(
                                attribute: VenueDetailedConstants.description),
                            address: VenueAddress(
                              street: _valueFor(attribute: 'address_street'),
                              town: _valueFor(attribute: 'address_town'),
                              county: _valueFor(attribute: 'address_county'),
                              postcode: _valueFor(attribute: 'address_postcode'),
                            ),
                            amenities: _valueFor(attribute: 'amenities_list'),
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
                            operationalHours: operationalHours,
                            fishingRules: _valueFor(attribute: 'fishing_rules'),
                          );
                          if (_fbKey.currentState.saveAndValidate()) {
                            final result =
                                VenueDetailedJSONSerializer().toMap(_venue);
                            final _latitude =
                                _valueFor(attribute: 'coordinates_latitude');
                            final _longitude =
                                _valueFor(attribute: 'coordinates_longitude');

                            if (_latitude != null && _longitude != null) {
                              final double _latitude = double.parse(
                                  _valueFor(attribute: 'coordinates_latitude'));
                              assert(_latitude is double);
                              final double _longitude = double.parse(
                                  _valueFor(attribute: 'coordinates_longitude'));
                              assert(_longitude is double);
                              result["coordinates"] = GeoPoint(
                                _latitude,
                                _longitude,
                              );
                            }

                            void _addPoint({VenueDetailed venue, String name, String id, double lat, double long}) {
                              print('adding point');
                              final _geo = Geoflutterfire();

                              VenueSearch venueSearch = VenueSearch(
                                name: venue.name,
                                id: id,
                                imageURL: null,
                                isLake: venue.isLake,
                                isShop: venue.isShop,
                                address: venue.address,
                                amenities: venue.amenities,
                                fishStocked: venue.fishStocked,
                                fishingTypes: venue.fishingTypes,
                              );

                              GeoFirePoint geoFirePoint =
                              _geo.point(latitude: lat, longitude: long);

                              final result = VenueSearchJSONSerializer().toMap(venueSearch);
                              result['position'] = geoFirePoint.data;

                              Firestore.instance
                                  .collection('venues_locations')
                                  .add(result).whenComplete(() {
                                print('added ${geoFirePoint.hash} successfully');
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Form successfully submitted'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                              'Tap Return to dismiss this page.'),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Return'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _fbKey.currentState.reset();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              });
                            }

                            Future postNewVenue() async {
                               await Firestore.instance
                                  .collection('venues_detail')
                                  .add(result).then((doc) {
                                 final double _latitude = double.parse(
                                     _valueFor(attribute: 'coordinates_latitude'));
                                 assert(_latitude is double);
                                 final double _longitude = double.parse(
                                     _valueFor(attribute: 'coordinates_longitude'));
                                 assert(_longitude is double);
                                 _addPoint(
                                   venue: _venue,
                                   name: result['name'],
                                   id: doc.documentID,
                                   lat: _latitude,
                                   long: _longitude,
                                 );
                              });
                            }

                            postNewVenue();
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'There was an issue trying to submit your form'),
                                    content: SingleChildScrollView(
                                      child: Text(
                                          'Please correct any incorrect entries and try again.'),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }),
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
        HouseTexts.subtitle('Add a Venue'),
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

class _FishingRulesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Fishing Rules'),
        SizedBox(height: 16),
        FormBuilderTextField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: null,
          attribute: "fishing_rules",
          decoration: InputDecoration(
              labelText: "Fishing Rules",
              helperText:
                  "Information on fishing rules and regulations for this venue",
              border: OutlineInputBorder()),
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
        HouseTexts.subtitle('Address'),
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
        HouseTexts.subtitle('Amenities'),
        FormBuilderTouchSpin(
          attribute: "amenities_num_lakes",
          decoration: InputDecoration(labelText: "Number of Lakes"),
          initialValue: 0,
          min: 0,
          max: 100,
          step: 1,
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
        HouseTexts.subtitle('Venue Contact Details'),
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
        HouseTexts.subtitle('Social Links'),
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
        HouseTexts.subtitle('Fish Stocked'),
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
        HouseTexts.subtitle('Fishing Types'),
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
        HouseTexts.subtitle('Tickets Available'),
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

class _CoordinatesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Coordinates'),
        FormBuilderTextField(
          attribute: "coordinates_latitude",
          decoration: InputDecoration(
            labelText: "Latitude *",
          ),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ],
        ),
        FormBuilderTextField(
          attribute: "coordinates_longitude",
          decoration: InputDecoration(labelText: "Longitude *"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ],
        ),
      ],
    );
  }
}

class _OperationalHoursSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Operational Hours'),
        SizedBox(height: 16),
        _OperationalHoursDay(day: 'Monday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Tuesday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Wednesday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Thursday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Friday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Saturday'),
        SizedBox(height: 8),
        _OperationalHoursDay(day: 'Sunday'),
      ],
    );
  }
}

class _OperationalHoursDay extends StatelessWidget {
  _OperationalHoursDay({this.day});

  final String day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text("$day"),
        ),
        FormBuilderDropdown(
          attribute: "${day.toLowerCase()}_open",
          decoration: InputDecoration(labelText: "Open"),
          hint: Text('Open'),
          items: OpeningHoursList.thirtyIntervalFromMorning
              .map(
                  (time) => DropdownMenuItem(value: time, child: Text("$time")))
              .toList(),
        ),
        FormBuilderDropdown(
          attribute: "${day.toLowerCase()}_close",
          decoration: InputDecoration(labelText: "Close"),
          hint: Text('Close'),
          items: OpeningHoursList.thirtyIntervalFromAfternoon
              .map(
                  (time) => DropdownMenuItem(value: time, child: Text("$time")))
              .toList(),
        ),
      ],
    );
  }
}

//class _OperationalHoursDay extends StatelessWidget {
//  _OperationalHoursDay({this.day});
//
//  final String day;
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        Align(
//          child: Text('$day'),
//          alignment: Alignment.centerLeft,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            Container(
//              width: 150,
//              child: FormBuilderDateTimePicker(
//                attribute: "monday_open",
//                autofocus: false,
//                inputType: InputType.time,
//                format: DateFormat.Hm(),
//                decoration: InputDecoration(labelText: "Open"),
//              ),
//            ),
//            Container(
//              width: 150,
//              child: FormBuilderDateTimePicker(
//                attribute: "monday_close",
//                autofocus: false,
//                inputType: InputType.time,
//                format: DateFormat.Hm(),
//                decoration: InputDecoration(labelText: "Close"),
//              ),
//            ),
//          ],
//        ),
//      ],
//    );
//  }
//}

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
