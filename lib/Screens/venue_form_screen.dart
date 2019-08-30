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
          attribute: "age",
          decoration: InputDecoration(labelText: "Name of Venue"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
          ],
        ),
        FormBuilderCheckboxList(
          decoration: InputDecoration(labelText: "Venue Type"),
          attribute: "languages",
          initialValue: ["Dart"],
          options: [
            FormBuilderFieldOption(value: "Lake"),
            FormBuilderFieldOption(value: "Shop"),
          ],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Description"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
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
          attribute: "age",
          decoration: InputDecoration(labelText: "Street"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
          ],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Town"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
          ],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "County"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
          ],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Postcode"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
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
          attribute: "age",
          decoration: InputDecoration(labelText: "Number of Lakes"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric()
          ],
        ),
        FormBuilderCheckboxList(
          attribute: "languages",
          initialValue: ["Dart"],
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
        _Header('Contact Details'),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Email"),
          validators: [
            FormBuilderValidators.email(),
          ],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Phone"),
          validators: [
            // TODO: Add validation for phone number
          ],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Website URL"),
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
          attribute: "age",
          decoration: InputDecoration(labelText: "Facebook"),
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Instagram"),
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "age",
          decoration: InputDecoration(labelText: "Twitter"),
          validators: [],
        ),
        FormBuilderTextField(
          attribute: "age",
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
          attribute: "languages",
          initialValue: ["Dart"],
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
          attribute: "languages",
          initialValue: ["Dart"],
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
          attribute: "languages",
          initialValue: ["Dart"],
          options: [
            FormBuilderFieldOption(value: "Day"),
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
