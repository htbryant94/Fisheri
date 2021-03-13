import 'package:fisheri/Components/add_button.dart';
import 'package:fisheri/Screens/catch_form_screen_full.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/base_cell.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';

import '../design_system.dart';

class CatchReportScreen extends StatelessWidget {
  CatchReportScreen({
    @required this.catchReport,
    @required this.catchReportID,
  });

  final CatchReport catchReport;
  final String catchReportID;

  @override
  Widget build(BuildContext context) {
    print('Catch Report id: $catchReportID');
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(child: _CatchListBuilder(id: catchReportID)),
            _NewCatchButton(onPressed: () {
              _pushNewCatchForm(context);
            }),
          ],
        ),
      ),
    );
  }

  void _pushNewCatchForm(BuildContext context) {
    final startDate = DateTime.parse(catchReport.startDate);
    final endDate = DateTime.parse(catchReport.endDate);

    var dateRange = List.generate(
        endDate.difference(startDate).inDays + 1,
        (day) =>
            DateTime(startDate.year, startDate.month, startDate.day + day));
    Coordinator.push(context,
        currentPageTitle: 'Catches',
        screen: CatchFormScreenFull(
          dateRange: dateRange,
          catchReportID: catchReportID,
        ),
        screenTitle: 'New Catch');
  }
}

class _NewCatchButton extends StatelessWidget {
  _NewCatchButton({
    this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return AddButton(
      title: 'New Catch',
      onPressed: onPressed,
    );
  }
}

class _CatchListBuilder extends StatelessWidget {
  _CatchListBuilder({@required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('catches')
          .where('catch_report_id', isEqualTo: id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(height: 0);
        }
        return ListView.separated(
            itemCount: snapshot.data.docs.length,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            separatorBuilder: (BuildContext context, int index) {
              return DSComponents.singleSpacer();
            },
            itemBuilder: (context, index) {
              final _catch = snapshot.data.docs[index];
              final _data = CatchJSONSerializer().fromMap(_catch.data());
//              print('catch index: $index with id: ${_catch.id}');
              return CatchCell(
                catchData: _data,
              );
            });
      },
    );
  }
}

class CatchCell extends StatelessWidget {
  CatchCell({
    this.catchData,
  });

  final Catch catchData;

  void _openCatchScreen(BuildContext context) {
    Coordinator.pushCatchDetailScreen(context,
        currentPageTitle: 'Report', catchData: catchData);
  }

  String _formattedDate(String date) {
    DateTime _dateTime = DateTime.parse(date);
    return DateFormat('E, d MMM').format(_dateTime);
  }

  String _subtitle() {
    if (catchData.weight != null) {
      return WeightConverter.gramsToPoundsAndOunces(catchData.weight);
    } else if (catchData.catchType != null) {
      return 'Type: ${ReCase(catchData.catchType).titleCase}';
    }
    return null;
  }

  String _title() {
    if (catchData.typeOfFish != null) {
      return ReCase(catchData.typeOfFish).titleCase;
    } else {
      return 'Match';
    }
  }

  String _makeImageURL(String fish) {
    if (fish != null) {
      final sanitisedFish = ReCase(fish).snakeCase;
      return 'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/fish%2Fstock_new%2F$sanitisedFish.png?alt=media&token=b8893ebd-5647-42a2-bfd3-9c2026f2703d';
    }
    return null;
  }

  String _makeMatchPositionImageURL(int position) {
    if (position != null) {
      return 'https://firebasestorage.googleapis.com/v0/b/fishing-finder-594f0.appspot.com/o/position%2F$position.png?alt=media&token=840bfbfb-a8a6-4295-a7fc-1e0d8a9ed3c6';
    }
    return null;
  }

  bool _isSingle() {
    return catchData.catchType == 'single';
  }

  bool _isMulti() {
    return catchData.catchType == 'multi';
  }

  bool _isMatch() {
    return catchData.catchType == 'match';
  }

  String _formattedPosition(int position) {
    if (position == 1) {
      return '${position}st';
    } else if (position == 2) {
      return '${position}nd';
    } else if (position == 3) {
      return '${position}rd';
    } else {
      return '${position}th';
    }
  }

  String _fetchImageURL(Catch data) {
    if (_isMatch()) {
      return _makeMatchPositionImageURL(catchData.position);
    } else if (data.images != null && data.images.isNotEmpty) {
      return data.images.first;
    } else {
      return _makeImageURL(catchData.typeOfFish);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _openCatchScreen(context);
        },
        child: Stack(
          children: [
            RemoteImageBaseCell(
              title: _title(),
              subtitle: _subtitle(),
              imageURL: _fetchImageURL(catchData),
              elements: [
                if (_isMulti())
                  DSComponents.subheaderSmall(text: 'x${catchData.numberOfFish}'),
                if (catchData.date != null)
                  DSComponents.bodySmall(
                      text: 'Date: ${_formattedDate(catchData.date)}'),
                if (catchData.time != null)
                  DSComponents.bodySmall(text: 'Time: ${catchData.time}'),
                if (_isMatch())
                  DSComponents.subheaderSmall(text: 'Position: ' + _formattedPosition(catchData.position)),
              ],
              height: 275,
              layout: BaseCellLayout.thumbnail,
              imageBoxFit: _isMatch() ? BoxFit.scaleDown : BoxFit.fitWidth,
            ),
            if (catchData.weatherCondition != null)
            Positioned(
              right: 16,
              top: 16,
              bottom: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    child: Image.asset('images/icons/weather/${ReCase(catchData.weatherCondition).snakeCase}.png'),
                  ),
                  if (catchData.temperature != null)
                    DSComponents.subheaderSmall(text: '${catchData.temperature.round()}°'),
                  if (catchData.windDirection != null)
                    DSComponents.subheaderSmall(text: '${catchData.windDirection.substring(0, 1).titleCase}')
                ],
              ),
            ),
          ],
        ));
  }
}
