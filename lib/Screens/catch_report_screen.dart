import 'package:fisheri/Components/add_button.dart';
import 'package:fisheri/Screens/catch_form_screen_full.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/models/catch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/base_cell.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';

import '../design_system.dart';

class CatchReportScreen extends StatelessWidget {
  CatchReportScreen({
    @required this.startDate,
    @required this.endDate,
    @required this.id,
  });

  final DateTime startDate;
  final DateTime endDate;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(child: _CatchListBuilder(id: id)),
            _NewCatchButton(onPressed: () {
              _pushNewCatchForm(context);
            }),
          ],
        ),
      ),
    );
  }

  void _pushNewCatchForm(BuildContext context) {
    var dateRange = List.generate(
        endDate.difference(startDate).inDays + 1,
        (day) =>
            DateTime(startDate.year, startDate.month, startDate.day + day));
    Coordinator.push(context,
        currentPageTitle: 'Catches',
        screen: CatchFormScreenFull(
          dateRange: dateRange,
          catchReportID: id,
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
      stream: Firestore.instance
          .collection('catches')
          .where('catch_report_id', isEqualTo: id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(height: 0);
        }
        return ListView.separated(
            itemCount: snapshot.data.documents.length,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            separatorBuilder: (BuildContext context, int index) {
              return DSComponents.singleSpacer();
            },
            itemBuilder: (context, index) {
              final _catch = snapshot.data.documents[index];
              final _data = CatchJSONSerializer().fromMap(_catch.data);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _openCatchScreen(context);
        },
        child: RemoteImageBaseCell(
          title: ReCase(catchData.typeOfFish).titleCase ?? "Match",
          subtitle: (catchData.typeOfFish != null)
              ? 'Catch: ${ReCase(catchData.catchType).titleCase}'
              : "Position: ${catchData.position}",
          elements: [
            if (catchData.time != null)
              DSComponents.bodySmall(text: 'Time: ${catchData.time}'),
            if (catchData.date != null)
              DSComponents.bodySmall(
                  text: 'Date: ${_formattedDate(catchData.date)}'),
          ],
          imageURL: null,
          height: 275,
          layout: BaseCellLayout.thumbnail,
        ));
  }
}
