import 'package:fisheri/Screens/catch_form_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/house_texts.dart';
import 'package:fisheri/models/catch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Components/base_cell.dart';

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
            Expanded(child: CatchListBuilder(id: id)),
            CupertinoButton(
              onPressed: () {
                var dateRange = List.generate(
                    endDate.difference(startDate).inDays + 1,
                        (day) => DateTime(startDate.year, startDate.month,
                        startDate.day + day));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CatchFormScreen(
                          dateRange: dateRange,
                          catchReportID: id,
                        )));
              },
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(Icons.add, color: Colors.white),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 8),
                  HouseTexts.heading('Add a new Catch'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CatchListBuilder extends StatelessWidget {
  CatchListBuilder({@required this.id});

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
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final _catch = snapshot.data.documents[index];
              final _data = CatchJSONSerializer().fromMap(_catch.data);
              return CatchCell(
                data: _data,
              );
            });
      },
    );
  }
}

class CatchCell extends StatelessWidget {
  CatchCell({
    this.data,
  });

  final Catch data;

  void _openCatchScreen(BuildContext context) {
    Coordinator.pushCatchDetailScreen(context, currentPageTitle: 'Report', catchData: data);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _openCatchScreen(context);
        },
        child: LocalImageBaseCell(
          title: data.typeOfFish,
          subtitle: data.catchType,
          image: Image.asset('images/lake.jpg'),
        ));
  }
}
