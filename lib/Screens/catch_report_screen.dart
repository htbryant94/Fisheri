import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/Screens/catch_form_screen.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/alert_dialog_factory.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fisheri/Components/base_cell.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';

import '../design_system.dart';
import '../firestore_request_service.dart';

class CatchReportScreen extends StatefulWidget {
  CatchReportScreen({
    @required this.catchReport,
    @required this.catchReportID,
  });

  static const routeName = '/catchReport';
  final CatchReport catchReport;
  final String catchReportID;


  @override
  _CatchReportScreenState createState() => _CatchReportScreenState();
}

class _CatchReportScreenState extends State<CatchReportScreen> {
  final int _initialPageValue = 0;
  int _segmentedControlSelectedValue;
  PageController _pageController;
  // Future<List<Catch>> _catches;

  @override
  void initState() {
    // _catches = FirestoreRequestService.defaultService().getCatches(catchReportID: widget.catchReportID);
    _pageController = PageController(initialPage: _initialPageValue);
    _segmentedControlSelectedValue = _initialPageValue;
    super.initState();
  }

  bool _shouldShowSummarySection() {
    return widget.catchReport.images != null || widget.catchReport.notes != null;
  }

  @override
  Widget build(BuildContext context) {
    print('Catch Report id: ${widget.catchReportID}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DSComponents.doubleSpacer(),
            CupertinoSegmentedControl(
                borderColor: DSColors.green,
                selectedColor: DSColors.green,
                groupValue: _segmentedControlSelectedValue,
                children: {
                  0: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Catches'),
                      )
                  ),
                  1: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Summary'),
                      )
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _segmentedControlSelectedValue = value;
                  });
                  _pageController.jumpToPage(_segmentedControlSelectedValue);
                }
            ),
            Flexible(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _segmentedControlSelectedValue = index;
                      });
                    },
                    children: [
                      // FutureBuilder<List<Catch>>(
                      //   future: _catches,
                      //   builder: (BuildContext context, AsyncSnapshot<List<Catch>> snapshot) {
                      //     if (snapshot.hasData) {
                      //       if (snapshot.data.isEmpty) {
                      //         return DSComponents.titleLarge(
                      //             text: 'No Catches  🎣',
                      //             alignment: Alignment.center
                      //         );
                      //       }
                      //       return _CatchListBuilder(catches: snapshot.data);
                      //     } else {
                      //       return Center(child: CircularProgressIndicator());
                      //     }
                      //   },
                      // ),
                      _CatchListBuilder(
                        catchReportID: widget.catchReportID,
                        catchReport: widget.catchReport,
                      ),
                      _shouldShowSummarySection() ? SingleChildScrollView(
                        child: Column(
                          children: [
                            DSComponents.doubleSpacer(),
                            if(widget.catchReport.images != null)
                            ImageCarousel(
                              imageURLs: widget.catchReport.images,
                              showFavouriteButton: false,
                              height: 300,
                            ),
                            if (widget.catchReport.notes != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 24, 24, 68),
                                child: Column(
                                  children: [
                                    DSComponents.header(text: 'Notes'),
                                    DSComponents.doubleSpacer(),
                                    DescriptionSection(
                                      text: widget.catchReport.notes,
                                    ),
                                  ],
                                ),
                              ),
                            CupertinoButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.delete_solid, color: Colors.red, size: 20),
                                    DSComponents.body(
                                      text: 'Delete',
                                      color: Colors.red,
                                      alignment: Alignment.center,
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  var _shouldDelete = false;
                                  await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialogFactory.deleteConfirmation(
                                            context: context,
                                            onDeletePressed: () {
                                              _shouldDelete = true;
                                              Navigator.of(context).pop();
                                            }
                                        );
                                      });

                                  if (_shouldDelete) {
                                    // delete Catch Report images
                                    if (widget.catchReport.images != null &&
                                        widget.catchReport.images.isNotEmpty) {
                                      await FireStorageRequestService
                                          .defaultService().deleteImages(
                                          widget.catchReport.images);
                                    }
                                    // get all Catches for Catch Report
                                    final catchDocuments = await FirestoreRequestService
                                        .defaultService().getCatches(
                                        catchReportID: widget.catchReportID);

                                    // delete images for each Catch
                                    catchDocuments.forEach((document) async {
                                      if (document.images != null &&
                                          document.images.isNotEmpty) {
                                        await FireStorageRequestService
                                            .defaultService().deleteImages(
                                            document.images);
                                      }
                                    });

                                    // delete Catches for Catch Report
                                    await FirestoreRequestService
                                        .defaultService()
                                        .deleteCatchesForCatchReport(
                                        widget.catchReportID);

                                    // delete Catch Report
                                    await FirestoreRequestService
                                        .defaultService()
                                        .deleteCatchReport(widget.catchReportID)
                                        .whenComplete(() {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                },
                            )
                          ],
                        ),
                      ) : DSComponents.titleLarge(
                          text: 'No Summary  📝',
                          alignment: Alignment.center
                      ),
                    ],

                  ),
                  Positioned(
                    bottom: 12,
                    left: 24,
                    right: 24,
                    child: _NewCatchButton(onPressed: () {
                      _pushNewCatchForm(
                        context: context,
                      );
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _pushNewCatchForm({BuildContext context}) {
    Coordinator.present(context,
        currentPageTitle: 'Catches',
        screen: CatchFormScreen(
          catchReportID: widget.catchReportID,
          catchReport: widget.catchReport,
          catchID: null,
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
    return DSComponents.primaryButton(
      text: 'New Catch',
      onPressed: onPressed,
    );
  }
}

class _CatchListBuilder extends StatefulWidget {
  _CatchListBuilder({
    @required this.catchReportID,
    @required this.catchReport,
  });

  final String catchReportID;
  final CatchReport catchReport;

  @override
  __CatchListBuilderState createState() => __CatchListBuilderState();
}

class __CatchListBuilderState extends State<_CatchListBuilder> {
  Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection('catches')
        .where('catch_report_id', isEqualTo: widget.catchReportID)
        .orderBy('date', descending: true)
        .orderBy('time', descending: true)
        .snapshots();

    _stream.listen((event) {
      print ('----- STREAM UPDATED -----');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
            return DSComponents.titleLarge(
                text: 'No Catches  🎣',
                alignment: Alignment.center
            );
          } else {
            return ListView.separated(
                itemCount: snapshot.data.docs.length,
                padding: EdgeInsets.fromLTRB(8, 24, 8, 68),
                separatorBuilder: (BuildContext context, int index) {
                  return DSComponents.singleSpacer();
                },
                itemBuilder: (context, index) {
                  final _catch = snapshot.data.docs[index];
                  final _data = CatchJSONSerializer().fromMap(_catch.data());
                  print('catch index: $index with id: ${_catch.id}');
                  return CatchCell(
                    catchData: _data,
                    catchID: _catch.id,
                    catchReport: widget.catchReport,
                    catchReportID: widget.catchReportID,
                    height: _data.catchType == 'missed' ? 200 : 275,
                  );
                });
          }
      },
    );
    // return ListView.separated(
    //     itemCount: catches.length,
    //     padding: EdgeInsets.fromLTRB(8, 24, 8, 68),
    //     separatorBuilder: (BuildContext context, int index) {
    //       return DSComponents.singleSpacer();
    //     },
    //     itemBuilder: (context, index) {
    //       final _catch = catches[index];
    //       return CatchCell(
    //         catchData: _catch,
    //         height: _catch.catchType == 'missed' ? 200 : 275,
    //       );
    //     });
  }
}

class CatchCell extends StatelessWidget {
  CatchCell({
    this.catchData,
    this.catchID,
    this.catchReport,
    this.catchReportID,
    this.height = 275
  });

  final Catch catchData;
  final String catchID;
  final CatchReport catchReport;
  final String catchReportID;
  final double height;

  void _openCatchScreen(BuildContext context) {
    Coordinator.pushCatchDetailScreen(
      context: context,
      currentPageTitle: 'Report',
      catchData: catchData,
      catchID: catchID,
      catchReport: catchReport,
      catchReportID: catchReportID
    );
  }

  String _formattedDate(String date) {
    DateTime _dateTime = DateTime.parse(date);
    return DateFormat('E, d MMM').format(_dateTime);
  }

  String _subtitle() {
    if (catchData.weight != null) {
      return WeightConverter.gramsToPoundsAndOunces(catchData.weight);
    }
    return null;
  }

  String _title() {
    if (catchData.typeOfFish != null) {
      return ReCase(catchData.typeOfFish).titleCase;
    } else {
      return ReCase(catchData.catchType).titleCase;
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
              showImage: catchData.catchType != 'missed',
              title: _title(),
              subtitle: catchData.catchType != 'missed' ? _subtitle() : null,
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
              height: height,
              layout: BaseCellLayout.thumbnail,
              imageBoxFit: _isMatch() ? BoxFit.scaleDown : BoxFit.fitWidth,
            ),
            if (catchData.weatherCondition != null && catchData.catchType != 'missed')
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
