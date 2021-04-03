import 'package:fisheri/Components/add_button.dart';
import 'package:fisheri/Screens/catch_report_form_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'catch_report_cell.dart';

class CatchReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(child: _CatchReportListBuilder()),
            _AddNewCatchReportButton(),
          ],
        ),
      ),
    );
  }
}

class _AddNewCatchReportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddButton(
      title: 'New Catch Report',
      onPressed: () {
        FirebaseFirestore.instance
            .collection('venues_search')
            .get()
            .then((documents) {
          Coordinator.present(context,
              currentPageTitle: '',
              screen: CatchReportFormScreen(availableLakes: documents),
              screenTitle: 'New Catch Report');
        });
      },
    );
  }
}

class _CatchReportListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('catch_reports').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              final _document = snapshot.data.docs[index];
              final _catchReport = CatchReportJSONSerializer().fromMap(_document.data());
              return CatchReportCell(
                catchReport: _catchReport,
                catchReportID: _document.id,
              );
            });
      },
    );
  }
}
