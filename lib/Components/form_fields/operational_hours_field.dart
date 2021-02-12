import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/models/hours_of_operation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';

enum DayOfTheWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
  everyDay,
}

class OperationalHoursField extends StatefulWidget {
  OperationalHoursField({
    this.hoursOfOperation,
    this.alwaysOpen,
    this.onChanged,
  });

  final HoursOfOperation hoursOfOperation;
  final ValueChanged<WeekDayState> onChanged;
  final alwaysOpen;

  @override
  OperationalHoursSectionState createState() => OperationalHoursSectionState();
}

class OperationalHoursSectionState extends State<OperationalHoursField> {

  bool _isAlwaysOpen;

  @override
  void initState() {
    super.initState();
    _isAlwaysOpen = widget.alwaysOpen;
  }

  _WeekDaySection _buildWeekDaySection(DayOfTheWeek day, OpeningHoursDay data) {
    return _WeekDaySection(
      day: day,
      data: data,
      onChanged: (isOpen) {
        widget.onChanged(WeekDayState(dayOfTheWeek: day, isOpen: isOpen));
      },
    );
  }

  OpeningHoursDay defaultOpeningHoursDay() {
    return OpeningHoursDay(open: '09:00', close: '17:00');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _isAlwaysOpen,
                  onChanged: (value) {
                    setState(() {
                      _isAlwaysOpen = value;
                    });
                    widget.onChanged(WeekDayState(dayOfTheWeek: DayOfTheWeek.everyDay, isOpen: value));
                  },
                ),
                Text('24 / 7'),
                ],
            ),
            Visibility(
              visible: !_isAlwaysOpen,
              child: Column(
                children: [
                  _buildWeekDaySection(DayOfTheWeek.monday, widget.hoursOfOperation != null ? widget.hoursOfOperation.monday : null),
                  _buildWeekDaySection(DayOfTheWeek.tuesday, widget.hoursOfOperation != null ? widget.hoursOfOperation.tuesday : null),
                  _buildWeekDaySection(DayOfTheWeek.wednesday, widget.hoursOfOperation != null ? widget.hoursOfOperation.wednesday : null),
                  _buildWeekDaySection(DayOfTheWeek.thursday, widget.hoursOfOperation != null ? widget.hoursOfOperation.thursday : null),
                  _buildWeekDaySection(DayOfTheWeek.friday, widget.hoursOfOperation != null ? widget.hoursOfOperation.friday : null),
                  _buildWeekDaySection(DayOfTheWeek.saturday, widget.hoursOfOperation != null ? widget.hoursOfOperation.saturday : null),
                  _buildWeekDaySection(DayOfTheWeek.sunday, widget.hoursOfOperation != null ? widget.hoursOfOperation.sunday : null),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class WeekDayState {
  WeekDayState({this.dayOfTheWeek, this.isOpen});

  final dayOfTheWeek;
  final isOpen;
}

class _WeekDaySection extends StatefulWidget {
  _WeekDaySection({
    this.day,
    this.data,
    this.onChanged,
  });

  final OpeningHoursDay data;
  final DayOfTheWeek day;
  final ValueChanged<bool> onChanged;

  @override
  __WeekDaySectionState createState() => __WeekDaySectionState();
}

class __WeekDaySectionState extends State<_WeekDaySection> {
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.data != null;
  }

  DateTime _initialOpeningTime({bool isOpen, OpeningHoursDay data}) {
    var timeAsFormattedString;
    if (isOpen && data != null) {
      timeAsFormattedString = data.open;
    } else {
      timeAsFormattedString = "09:00";
    }
    return DateFormat('HH:mm').parse(timeAsFormattedString);
  }

  DateTime _initialClosingTime({bool isOpen, OpeningHoursDay data}) {
    var timeAsFormattedString;
    if (isOpen && data != null) {
      timeAsFormattedString = data.close;
    } else {
      timeAsFormattedString = "17:00";
    }
    return DateFormat('HH:mm').parse(timeAsFormattedString);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: _isOpen,
                onChanged: (value) {
                  widget.onChanged(value);
                  setState(() {
                    _isOpen = value;
                  });
                },
              ),
              Text(ReCase(describeEnum(widget.day)).titleCase),
            ]
        ),
        Visibility(
          visible: _isOpen,
          child: FormBuilderDateTimePicker(
            name: "${describeEnum(widget.day)}_open",
            decoration: InputDecoration(labelText: "Open"),
            inputType: InputType.time,
            alwaysUse24HourFormat: true,
            initialValue: _initialOpeningTime(isOpen: _isOpen, data: widget.data),
            validator: FormBuilderValidators.required(context),
          ),
        ),
        Visibility(
          visible: _isOpen,
          child: FormBuilderDateTimePicker(
            name: "${describeEnum(widget.day)}_close",
            decoration: InputDecoration(labelText: "Close"),
            inputType: InputType.time,
            initialValue: _initialClosingTime(isOpen: _isOpen, data: widget.data),
            alwaysUse24HourFormat: true,
            validator: FormBuilderValidators.required(context),
          ),
        ),
      ],
    );
  }
}