import 'dart:ui';

import 'package:fisheri/Components/form_builder_image_picker_custom.dart';
import 'package:fisheri/Components/form_fields/fishing_types_field.dart';
import 'package:fisheri/Components/form_fields/social_media_field.dart';
import 'package:fisheri/Screens/venue_form_edit_screen.dart';
import 'package:fisheri/house_colors.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:fisheri/models/venue_address.dart';
import 'package:fisheri/models/venue_detailed.dart';
import 'package:fisheri/models/venue_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:fisheri/house_texts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:recase/recase.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:fisheri/Components/form_fields/operational_hours_field.dart';

class VenueDetailedConstants {
  static const String name = "name";
  static const String isLake = "is_lake";
  static const String isaShop = "is_shop";
  static const String categories = "categories";
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
  List<String> imageURLs = [];
  List<String> selectedCategories = [];
  bool _isLoading = false;

  bool _operationalHoursEnabled = false;
  bool _alwaysOpen = false;
  bool _isMondayOpen = false;
  bool _isTuesdayOpen = false;
  bool _isWednesdayOpen = false;
  bool _isThursdayOpen = false;
  bool _isFridayOpen = false;
  bool _isSaturdayOpen = false;
  bool _isSundayOpen = false;

  @override
  Widget build(BuildContext context) {
    bool isLake() {
      return selectedCategories.contains('lake');
    }

    bool isShop() {
      return selectedCategories.contains('shop');
    }

    Function _valueFor = ({String attribute}) {
      return _fbKey.currentState.fields[attribute].value;
    };

    HoursOfOperation getOperationalHours() {
      OpeningHoursDay monday;
      OpeningHoursDay tuesday;
      OpeningHoursDay wednesday;
      OpeningHoursDay thursday;
      OpeningHoursDay friday;
      OpeningHoursDay saturday;
      OpeningHoursDay sunday;

      if (_isMondayOpen) {
        print('monday');
        monday = OpeningHoursDay(
          open: DateFormat('HH:mm').format(_valueFor(attribute: 'monday_open')),
          close:
          DateFormat('HH:mm').format(_valueFor(attribute: 'monday_close')),
        );
      }

      if (_isTuesdayOpen) {
        print('tuesday');
        tuesday = OpeningHoursDay(
          open:
          DateFormat('HH:mm').format(_valueFor(attribute: 'tuesday_open')),
          close:
          DateFormat('HH:mm').format(_valueFor(attribute: 'tuesday_close')),
        );
      }

      if (_isWednesdayOpen) {
        print('wednesday');
        wednesday = OpeningHoursDay(
          open: DateFormat('HH:mm')
              .format(_valueFor(attribute: 'wednesday_open')),
          close: DateFormat('HH:mm')
              .format(_valueFor(attribute: 'wednesday_close')),
        );
      }

      if (_isThursdayOpen) {
        print('thursday');
        thursday = OpeningHoursDay(
          open:
          DateFormat('HH:mm').format(_valueFor(attribute: 'thursday_open')),
          close: DateFormat('HH:mm')
              .format(_valueFor(attribute: 'thursday_close')),
        );
      }

      if (_isFridayOpen) {
        print('friday');
        friday = OpeningHoursDay(
          open: DateFormat('HH:mm').format(_valueFor(attribute: 'friday_open')),
          close:
          DateFormat('HH:mm').format(_valueFor(attribute: 'friday_close')),
        );
      }

      if (_isSaturdayOpen) {
        print('saturday');
        saturday = OpeningHoursDay(
          open:
          DateFormat('HH:mm').format(_valueFor(attribute: 'saturday_open')),
          close: DateFormat('HH:mm')
              .format(_valueFor(attribute: 'saturday_close')),
        );
      }

      if (_isSundayOpen) {
        print('sunday');
        sunday = OpeningHoursDay(
          open: DateFormat('HH:mm').format(_valueFor(attribute: 'sunday_open')),
          close:
          DateFormat('HH:mm').format(_valueFor(attribute: 'sunday_close')),
        );
      }

      return HoursOfOperation(
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday,
      );
    }

    VenueDetailed makeVenueDetailed() {
      return VenueDetailed(
        name: _valueFor(attribute: VenueDetailedConstants.name),
        categories: _valueFor(attribute: 'categories'),
        description: _valueFor(attribute: VenueDetailedConstants.description),
        address: VenueAddress(
          street: _valueFor(attribute: 'address_street'),
          town: _valueFor(attribute: 'address_town'),
          county: _valueFor(attribute: 'address_county'),
          postcode: _valueFor(attribute: 'address_postcode'),
        ),
        numberOfLakes: isLake() ? _valueFor(attribute: 'number_of_lakes') : null,
        amenities: isLake() ? _valueFor(attribute: 'amenities_list') : null,
        contactDetails: ContactDetails(
          email: _valueFor(attribute: 'contact_email'),
          phone: _valueFor(attribute: 'contact_phone'),
        ),
        social: Social(
          facebook: _valueFor(attribute: 'social_facebook').toString().isNotEmpty ? _valueFor(attribute: 'social_facebook') : null,
          instagram: _valueFor(attribute: 'social_instagram').toString().isNotEmpty ? _valueFor(attribute: 'social_instagram') : null,
          twitter: _valueFor(attribute: 'social_twitter').toString().isNotEmpty ? _valueFor(attribute: 'social_twitter') : null,
          youtube: _valueFor(attribute: 'social_youtube').toString().isNotEmpty ? _valueFor(attribute: 'social_youtube') : null,
        ),
        fishStocked: isLake() ? _valueFor(attribute: 'fish_stocked') : null,
        fishingTackles:
            isShop() ? _valueFor(attribute: 'fishing_tackles') : null,
        fishingTypes: isLake() ? _valueFor(attribute: 'fishing_types') : null,
        tickets: isLake() ? _valueFor(attribute: 'tickets') : null,
        operationalHours: (_operationalHoursEnabled && !_alwaysOpen) ? getOperationalHours() : null,
        alwaysOpen: _alwaysOpen,
        fishingRules: isLake() ? _valueFor(attribute: 'fishing_rules') : null,
        images: imageURLs.isNotEmpty ? imageURLs : null,
        websiteURL: _valueFor(attribute: 'contact_url'),
      );
    }

    VenueSearch makeVenueSearch({VenueDetailed venue, String id}) {
      return VenueSearch(
        name: venue.name,
        categories: venue.categories,
        id: id,
        imageURL: imageURLs.isNotEmpty ? imageURLs.first : null,
        address: venue.address,
        numberOfLakes: venue.numberOfLakes,
        amenities: venue.amenities,
        fishStocked: venue.fishStocked,
        fishingTackles: venue.fishingTackles,
        fishingTypes: venue.fishingTypes,
        alwaysOpen: venue.alwaysOpen,
      );
    }

    Map<String, dynamic> addCoordinatesIfValid(Map<String, dynamic> result) {
      final _latitude = _valueFor(attribute: 'coordinates_latitude');
      final _longitude = _valueFor(attribute: 'coordinates_longitude');

      if (_latitude != null && _longitude != null) {
        final double _latitude =
            double.parse(_valueFor(attribute: 'coordinates_latitude'));
        assert(_latitude is double);
        final double _longitude =
            double.parse(_valueFor(attribute: 'coordinates_longitude'));
        assert(_longitude is double);
        result["coordinates"] = GeoPoint(
          _latitude,
          _longitude,
        );
      }
      return result;
    }

    Future uploadFile({String id, File file, String name}) async {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('venues/$id/images/$name');
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() {
        print('-----FILE UPLOADED-----');
        storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            // 3. Store URLs globally
            setState(() {
              imageURLs.add(fileURL);
            });
            print('File URL: $fileURL');
            print('Total URLS: $imageURLs');
          });
        });
      });
    }

    void _addPoint({
      VenueSearch venueSearch,
      double lat,
      double long,
    }) {
      print('adding point');
      final _geo = Geoflutterfire();
      GeoFirePoint geoFirePoint = _geo.point(latitude: lat, longitude: long);
      final result = VenueSearchJSONSerializer().toMap(venueSearch);
      result['position'] = geoFirePoint.data;

      FirebaseFirestore.instance
          .collection('venues_search')
          .doc(venueSearch.id)
          .set(result, SetOptions(merge: false))
          .whenComplete(() {
            setState(() {
              _isLoading = false;
            });
        print('added ${geoFirePoint.hash} successfully');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Form successfully submitted'),
                content: SingleChildScrollView(
                  child: Text('Tap Return to dismiss this page.'),
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

    Future amendVenue(String id, VenueDetailed venue) async {
      var venueJSON = VenueDetailedJSONSerializer().toMap(venue);
      venueJSON = addCoordinatesIfValid(venueJSON);

      await FirebaseFirestore.instance
          .collection('venues_detail')
          .doc(id)
          .set(venueJSON, SetOptions(merge: false))
          .then((doc) {
        final  _latitude = double.parse(_valueFor(attribute: 'coordinates_latitude'));
        assert(_latitude is double);
        final _longitude = double.parse(_valueFor(attribute: 'coordinates_longitude'));
        assert(_longitude is double);

        // 5. Create VenueSearch Object with fileURLs added
        final venueSearch = makeVenueSearch(id: id, venue: venue);

        // 6. setData for node in venues_search with VenueSearch object
        _addPoint(venueSearch: venueSearch, lat: _latitude, long: _longitude);
      });
    }

    // 2. Upload files to asset path with auto ID
    Future uploadFiles(VenueDetailed venue, String venueID) async {
      print('uploading files started');
      final List<dynamic> _images = _valueFor(attribute: 'images');
      final List<ImageType> parsedImageTypes = _images.map((image) {
        if (image is File) {
          return ImageType(type: "FILE", file: image);
        } else if (image is String) {
          return ImageType(type: "STRING", url: image);
        } else {
          return null;
        }
      }).toList();
      print('filesToUpload value -------');
      parsedImageTypes.forEach((imageType) {
        if (imageType.type == "URL") {
          print('imageType is: ${imageType.url}');
        } else if (imageType.type == "FILE") {
          print('imageType is: ${imageType.file}');
        }
      });

      if (parsedImageTypes != null) {
        var index = 0;
        await Future.forEach(parsedImageTypes, (imageType) async {
          print('----- uploading file: $index');

          final _imageType = imageType as ImageType;
          if (_imageType.type == "FILE") {
            await uploadFile(id: venueID, file: _imageType.file, name: '$index')
                .whenComplete(() {
              index += 1;
              print('----- uploaded file: $index');
            });
          } else if (_imageType.type == "URL") {
            index += 1;
            setState(() {
              imageURLs.add(_imageType.url);
            });
          }
        }).whenComplete(() {
          print('uploading files finished');
          // 4. setData for node in venues_detail with VenueDetailed Object
          print('AMENDING VENUE');

          venue.images = imageURLs;
          amendVenue(venueID, venue);
        });
      } else {
        print('----- no files to upload, amending venue');
        print('AMENDING VENUE');

        venue.images = imageURLs;
        await amendVenue(venueID, venue);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Listener(
          onPointerDown: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild.unfocus();
            }
          },
          child: Stack(
            children: [
              ListView(
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
                        child: Column(
                          children: <Widget>[
                            _OverviewSection(),
                            SizedBox(height: 16),
                            FormBuilderCheckboxGroup(
                              name: 'categories',
                              orientation: OptionsOrientation.vertical,
                              decoration:
                                  InputDecoration(labelText: 'Categories *'),
                              activeColor: HouseColors.accentGreen,
                              checkColor: HouseColors.primaryGreen,
                              onChanged: (categories) {
                                setState(() {
                                  selectedCategories =
                                      categories.cast<String>();
                                });
                              },
                              options: [
                                FormBuilderFieldOption(
                                    value: "lake", child: Text('Lake')),
                                FormBuilderFieldOption(
                                    value: "shop", child: Text('Shop')),
                              ],
                            ),
                            FormBuilderTextField(
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              maxLines: null,
                              name: "description",
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText: "Description",
                                  helperText:
                                      "Include pricing information or details on how to get to your venue here",
                                  border: OutlineInputBorder()),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.minLength(context, 4),
                                FormBuilderValidators.maxLength(context, 1000),
                              ]),
                            ),
                            SizedBox(height: 16),
                            _CoordinatesSection(),
                            SizedBox(height: 16),
                            _AddressSection(),
                            SizedBox(height: 16),
                            Visibility(
                              visible: isLake(),
                              child: _AmenitiesSection(),
                            ),
                            _ContactDetailsSection(),
                            SizedBox(height: 16),
                            SocialMediaField(),
                            SizedBox(height: 16),
                            Visibility(
                              visible: isShop(),
                              child: FishingTypesField(
                                title: 'Shop: Fishing Tackle',
                                attribute: 'fishing_tackles',
                                fishingTypes: FishingTypes.values,
                              ),
                            ),
                            Visibility(
                              visible: isLake(),
                              child: _FishStockedSection(),
                            ),
                            Visibility(
                              visible: isLake(),
                              child: FishingTypesField(
                                title: 'Lake: Fishing Types',
                                attribute: 'fishing_types',
                                fishingTypes: [
                                  FishingTypes.carp,
                                  FishingTypes.catfish,
                                  FishingTypes.coarse,
                                  FishingTypes.fly,
                                  FishingTypes.match,
                                  FishingTypes.predator,
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isLake(),
                              child: _TicketsSection(),
                            ),
                            Visibility(
                              visible: isLake(),
                              child: _FishingRulesSection(),
                            ),
                            FormBuilderSwitch(
                              name: 'operational_hours_enabled',
                              initialValue: false,
                              title: HouseTexts.subheading(
                                  'Provide Opening times'),
                              onChanged: (enabled) {
                                setState(() {
                                  _operationalHoursEnabled = enabled;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            Visibility(
                              visible: _operationalHoursEnabled,
                              child: OperationalHoursField(
                                hoursOfOperation: null,
                                alwaysOpen: false,
                                onChanged: (weekDayState) {
                                  switch (weekDayState.dayOfTheWeek) {
                                    case DayOfTheWeek.monday:
                                      _isMondayOpen = weekDayState.isOpen;
                                      break;
                                    case DayOfTheWeek.tuesday:
                                      _isTuesdayOpen = weekDayState.isOpen;
                                      break;
                                    case DayOfTheWeek.wednesday:
                                      _isWednesdayOpen = weekDayState.isOpen;
                                      break;
                                    case DayOfTheWeek.thursday:
                                      _isThursdayOpen = weekDayState.isOpen;
                                      break;
                                    case DayOfTheWeek.friday:
                                      _isFridayOpen = weekDayState.isOpen;
                                      break;
                                    case DayOfTheWeek.saturday:
                                      _isSaturdayOpen = weekDayState.isOpen;
                                      break;
                                    case DayOfTheWeek.sunday:
                                      _isSundayOpen = weekDayState.isOpen;
                                      break;
                                    case DayOfTheWeek.everyDay:
                                      _alwaysOpen = weekDayState.isOpen;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            FormBuilderImagePicker(name: 'images'),
//                            FormBuilderImagePickerCustom(
//                              attribute: 'images',
//                            )
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          MaterialButton(
                              child: Text("Submit"),
                              onPressed: () {
                                Future postNewVenue(VenueDetailed venue,
                                    Map<String, dynamic> data) async {
                                  await FirebaseFirestore.instance
                                      .collection('venues_detail')
                                      .add(data)
                                      .then((doc) {
                                    final double _latitude = double.parse(
                                        _valueFor(
                                            attribute: 'coordinates_latitude'));
                                    assert(_latitude is double);
                                    final double _longitude = double.parse(
                                        _valueFor(
                                            attribute:
                                                'coordinates_longitude'));
                                    assert(_longitude is double);

                                    uploadFiles(venue, doc.id);
                                  });
                                }

                                if (_fbKey.currentState.saveAndValidate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var _venue = makeVenueDetailed();
                                  var _venueJSON = VenueDetailedJSONSerializer()
                                      .toMap(_venue);
                                  _venueJSON =
                                      addCoordinatesIfValid(_venueJSON);
                                  print(_venueJSON);

                                  postNewVenue(_venue, _venueJSON);
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
              Visibility(
                visible: _isLoading,
                child: Positioned.fill(
                  child: AbsorbPointer(
                    child: Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 24),
                            HouseTexts.heading('Submitting Changes...', alignment: Alignment.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        HouseTexts.subtitle('Add a Venue'),
        FormBuilderTextField(
          name: "name",
          decoration: InputDecoration(labelText: "Name of Venue *"),
          maxLines: 1,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.minLength(context, 4),
            FormBuilderValidators.maxLength(context, 50),
          ]),
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
          name: "fishing_rules",
          decoration: InputDecoration(
              labelText: "Fishing Rules",
              helperText:
                  "Information on fishing rules and regulations for this venue",
              border: OutlineInputBorder()),
        ),
        SizedBox(height: 16)
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
          name: "address_street",
          decoration: InputDecoration(labelText: "Street *"),
          maxLines: 1,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.minLength(context, 4),
            FormBuilderValidators.maxLength(context, 100),
          ]),
        ),
        FormBuilderTextField(
          name: "address_town",
          decoration: InputDecoration(labelText: "Town *"),
          maxLines: 1,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.minLength(context, 4),
            FormBuilderValidators.maxLength(context, 100),
          ]),
        ),
        FormBuilderTextField(
          name: "address_county",
          decoration: InputDecoration(labelText: "County *"),
          maxLines: 1,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.minLength(context, 4),
            FormBuilderValidators.maxLength(context, 100),
          ]),
        ),
        FormBuilderTextField(
          name: "address_postcode",
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: "Postcode *"),
          maxLines: 1,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.minLength(context, 6),
            FormBuilderValidators.maxLength(context, 8),
          ]),
        ),
      ],
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  final ReCase toilets = ReCase(describeEnum(Amenities.toilets));
  final ReCase showers = ReCase(describeEnum(Amenities.showers));
  final ReCase foodAndDrink = ReCase(describeEnum(Amenities.foodAndDrink));
  final ReCase nightFishing = ReCase(describeEnum(Amenities.nightFishing));
  final ReCase wheelchairAccess =
      ReCase(describeEnum(Amenities.wheelchairAccess));
  final ReCase guestsAllowed = ReCase(describeEnum(Amenities.guestsAllowed));
  final ReCase trolleyHire = ReCase(describeEnum(Amenities.trolleyHire));
  final ReCase takeawayFriendly =
      ReCase(describeEnum(Amenities.takeawayFriendly));
  final ReCase animalFriendly = ReCase(describeEnum(Amenities.animalFriendly));
  final ReCase tuition = ReCase(describeEnum(Amenities.tuition));
  final ReCase electricity = ReCase(describeEnum(Amenities.electricity));
  final ReCase equipmentHire = ReCase(describeEnum(Amenities.equipmentHire));
  final ReCase wifi = ReCase(describeEnum(Amenities.wifi));
  final ReCase camping = ReCase(describeEnum(Amenities.camping));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Amenities'),
        FormBuilderTouchSpin(
          name: 'number_of_lakes',
          decoration: InputDecoration(labelText: 'Number of Lakes'),
          initialValue: 0,
          min: 0,
          max: 100,
          step: 1,
        ),
        FormBuilderCheckboxGroup(
          name: 'amenities_list',
          orientation: OptionsOrientation.vertical,
          options: [
            FormBuilderFieldOption(
                value: toilets.snakeCase, child: Text(toilets.titleCase)),
            FormBuilderFieldOption(
                value: showers.snakeCase, child: Text(showers.titleCase)),
            FormBuilderFieldOption(
                value: foodAndDrink.snakeCase,
                child: Text(foodAndDrink.titleCase)),
            FormBuilderFieldOption(
                value: nightFishing.snakeCase,
                child: Text(nightFishing.titleCase)),
            FormBuilderFieldOption(
                value: wheelchairAccess.snakeCase,
                child: Text(wheelchairAccess.titleCase)),
            FormBuilderFieldOption(
                value: guestsAllowed.snakeCase,
                child: Text(guestsAllowed.titleCase)),
            FormBuilderFieldOption(
                value: trolleyHire.snakeCase,
                child: Text(trolleyHire.titleCase)),
            FormBuilderFieldOption(
                value: takeawayFriendly.snakeCase,
                child: Text(takeawayFriendly.titleCase)),
            FormBuilderFieldOption(
                value: animalFriendly.snakeCase,
                child: Text(animalFriendly.titleCase)),
            FormBuilderFieldOption(
                value: tuition.snakeCase, child: Text(tuition.titleCase)),
            FormBuilderFieldOption(
                value: electricity.snakeCase,
                child: Text(electricity.titleCase)),
            FormBuilderFieldOption(
                value: equipmentHire.snakeCase,
                child: Text(equipmentHire.titleCase)),
            FormBuilderFieldOption(
                value: wifi.snakeCase, child: Text(wifi.titleCase)),
            FormBuilderFieldOption(
                value: camping.snakeCase, child: Text(camping.titleCase)),
          ],
        ),
        SizedBox(height: 16)
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
           name: "contact_email",
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: "Email",
            icon: Icon(Icons.email),
          ),
          maxLines: 1,
          validator:FormBuilderValidators.email(context),
        ),
        FormBuilderTextField(
          name: 'contact_phone',
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone',
            icon: Icon(Icons.phone),
          ),
          maxLines: 1,
//          validator: // TODO: Add validation for phone number
        ),
        FormBuilderTextField(
          name: 'contact_url',
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Website URL',
            icon: Icon(Icons.language),
            prefixText: "www.",
            helperText: "e.g. www.fisheri.co.uk",
          ),
          maxLines: 1,
          validator: FormBuilderValidators.url(context),
        ),
      ],
    );
  }
}

enum FishStockList {
  barbel,
  bream,
  brownTrout,
  chub,
  commonCarp,
  crucianCarp,
  dace,
  eel,
  grassCarp,
  grayling,
  gudgeon,
  ide,
  koiCarp,
  mirrorCarp,
  orfe,
  perch,
  pike,
  rainbowTrout,
  roach,
  rudd,
  ruffe,
  salmon,
  tench,
  welsCatfish,
  zander
}

class _FishStockedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<FormBuilderFieldOption> options() {
      final fishStocked = FishStockList.values;
      return fishStocked
          .map((fish) => FormBuilderFieldOption(
                value: ReCase(describeEnum(fish)).snakeCase,
                child: Text(ReCase(describeEnum(fish)).titleCase),
              ))
          .toList();
    }

    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Fish Stocked'),
        FormBuilderCheckboxGroup(
          name: 'fish_stocked',
          orientation: OptionsOrientation.vertical,
          options: options(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

enum Tickets {
  day,
  night,
  season,
  syndicate,
  clubWater,
}

class _TicketsSection extends StatelessWidget {
  final ReCase day = ReCase(describeEnum(Tickets.day));
  final ReCase night = ReCase(describeEnum(Tickets.night));
  final ReCase season = ReCase(describeEnum(Tickets.season));
  final ReCase syndicate = ReCase(describeEnum(Tickets.syndicate));
  final ReCase clubWater = ReCase(describeEnum(Tickets.clubWater));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HouseTexts.subtitle('Tickets Available'),
        FormBuilderCheckboxGroup(
          name: 'tickets',
          orientation: OptionsOrientation.vertical,
          options: [
            FormBuilderFieldOption(
                value: day.snakeCase, child: Text(day.titleCase)),
            FormBuilderFieldOption(
                value: night.snakeCase, child: Text(night.titleCase)),
            FormBuilderFieldOption(
                value: season.snakeCase, child: Text(season.titleCase)),
            FormBuilderFieldOption(
                value: syndicate.snakeCase, child: Text(syndicate.titleCase)),
            FormBuilderFieldOption(
                value: clubWater.snakeCase, child: Text(clubWater.titleCase)),
          ],
        ),
        SizedBox(height: 16)
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
          name: "coordinates_latitude",
          maxLines: 1,
          keyboardType: TextInputType.numberWithOptions(signed: true),
          decoration: InputDecoration(
            labelText: "Latitude *",
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.numeric(context),
          ]),
        ),
        FormBuilderTextField(
          name: "coordinates_longitude",
          maxLines: 1,
          keyboardType: TextInputType.numberWithOptions(signed: true),
          decoration: InputDecoration(labelText: "Longitude *"),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.numeric(context),
          ]),
        ),
      ],
    );
  }
}
