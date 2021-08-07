import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisheri/Screens/catch_report_form_screen.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/design_system.dart';
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
        child: Stack(
          children: [
            _CatchReportListBuilder(),
            Positioned(
              bottom: 12,
              left: 24,
              right: 24,
              child: _AddNewCatchReportButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddNewCatchReportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DSComponents.primaryButton(
      text: 'New Catch Report',
      onPressed: () {
        Coordinator.present(
            context,
            currentPageTitle: '',
            screen: CatchReportFormScreen(),
            screenTitle: 'New Catch Report'
        );
      },
    );
  }
}

class _CatchReportListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore
          .instance
          .collection('catch_reports')
          .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .orderBy('start_date', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 68),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              final _document = snapshot.data.docs[index];
              // final _catchReport = CatchReportJSONSerializer().fromMap(_document.data());
              final _catchReport = CatchReport(); // TEMP
              return CatchReportCell(
                catchReport: _catchReport,
                catchReportID: _document.id,
              );
            });
      },
    );
  }
}
