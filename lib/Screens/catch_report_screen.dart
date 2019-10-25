import 'package:fisheri/Screens/catch_detail_screen.dart';
import 'package:fisheri/Screens/catch_form_screen.dart';
import 'package:fisheri/Screens/detail_screen/header.dart';
import 'package:fisheri/house_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Your Catch Reports'),
          backgroundColor: HouseColors.primaryGreen,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  height: 50,
                  minWidth: 50,
                  color: Colors.green[400],
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
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(child: CatchListBuilder(id: id)),
          ],
        ));
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
            padding: EdgeInsets.only(left: 8, right: 8),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final _catch = snapshot.data.documents[index];
              return CatchCell(
                catchType: _catch['catch_type'],
                date: _catch['date'],
                name: _catch['catch_report_id'],
                notes: _catch['notes'],
                temperature: _catch['temperature'],
                time: _catch['time'],
                type: _catch['catch_type'],
                typeOfFish: _catch['type_of_fish'],
                weatherCondition: _catch['weather_condition'],
                weight: _catch['weight'],
                windDirection: _catch['wind_direction'],
              );
            });
      },
    );
  }
}

class CatchCell extends StatelessWidget {
  CatchCell({
    this.catchType,
    this.date,
    this.name,
    this.notes,
    this.temperature,
    this.time,
    this.type,
    this.typeOfFish,
    this.weatherCondition,
    this.weight,
    this.windDirection,
  });

  final String catchType;
  final String date;
  final String name;
  final String notes;
  final double temperature;
  final String time;
  final String type;
  final String typeOfFish;
  final String weatherCondition;
  final double weight;
  final String windDirection;

  void _openCatchScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CatchDetailScreen(
                  catchType: catchType,
                  date: date != null
                      ? DateFormat('EEEE, MMM d, yyyy')
                          .format(DateTime.parse(date))
                      : "No Date",
                  fishType: typeOfFish,
                  notes: notes,
                  temperature: temperature,
                  time: time,
                  weatherCondition: weatherCondition,
                  weight: weight,
                  windDirection: windDirection,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openCatchScreen(context);
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3,
//        margin: EdgeInsets.only(top: 8, bottom: 8),
        child: Container(
          height: 120,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(
                            image: AssetImage('images/lake.jpg'),
                            fit: BoxFit.fill),
                        color: HouseColors.primaryGreen),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$typeOfFish',
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: HouseColors.wetAsphalt,
                      ),
                    ),
                    Text(
                      type,
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: HouseColors.concrete,
                      ),
                    ),
                    Text(
                      'id: $name',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        color: HouseColors.wetAsphalt,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
