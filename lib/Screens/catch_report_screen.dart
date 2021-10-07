// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisheri/FirestoreCollections.dart';
import 'package:fisheri/Screens/catch_form_screen.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/WeightConverter.dart';
import 'package:fisheri/Factories/alert_dialog_factory.dart';
import 'package:fisheri/coordinator.dart';
import 'package:fisheri/models/catch.dart';
import 'package:fisheri/models/catch_report.dart';
import 'package:fisheri/models/fisheri_image.dart';
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
                              imageURLs: widget.catchReport.images.map((e) => e.url).toList(),
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
                            _DeleteCatchButton(
                                images: widget.catchReport.images,
                                catchReportID: widget.catchReportID,
                            )
                          ],
                        ),
                      ) : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DSComponents.titleLarge(
                              text: 'No Summary  📝',
                              alignment: Alignment.center
                          ),
                          _DeleteCatchButton(
                            images: widget.catchReport.images,
                            catchReportID: widget.catchReportID,
                          )
                        ],
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
        .collection(FirestoreCollections.catches)
        .where('catch_report_id', isEqualTo: widget.catchReportID)
        // .orderBy('date', descending: true) // TODO: Reintroduce filter / sort
        // .orderBy('time', descending: true)
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
                  final _data = Catch.fromJson(_catch.data());
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

  Image _getMatchPositionPlaceholderIcon(int position) {
    if (position != null && position <= 3) {
      return Image.asset(
        'images/icons/match_positions/$position.png',
        height: 32,
        width: 32,
        fit: BoxFit.scaleDown,
      );
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
    if (_isMatch() && data.images == null) {
      return null;
    } else if (data.images != null && data.images.isNotEmpty) {
      return data.images.first.url;
    } else {
      return _makeImageURL(catchData.typeOfFish);
    }
  }

  bool _shouldShowImage() {
    if (catchData.catchType == 'missed' || (catchData.catchType == 'match' && catchData.position > 3)) {
      return false;
    } else {
      return true;
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
              showImage: _shouldShowImage(),
              title: _title(),
              subtitle: catchData.catchType != 'missed' ? _subtitle() : null,
              imageURL: _fetchImageURL(catchData),
              image:_getMatchPositionPlaceholderIcon(catchData.position),
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
              imagePadding: _isMatch() && catchData.images == null ? 24 : 0,
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

class _DeleteCatchButton extends StatelessWidget {
  _DeleteCatchButton({
    this.images,
    this.catchReportID
});

  final List<FisheriImage> images;
  final String catchReportID;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
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
        if (images != null && images.isNotEmpty) {
        await FireStorageRequestService.defaultService().deleteImages(images);
        }
        // get all Catches for Catch Report
        final catchDocuments = await FirestoreRequestService
            .defaultService().getCatches(
        catchReportID: catchReportID);

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
            .deleteCatchesForCatchReport(catchReportID);

        // delete Catch Report
        await FirestoreRequestService
            .defaultService()
            .deleteCatchReport(catchReportID)
            .whenComplete(() {
        Navigator.of(context).pop();
        });
        }
      },
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
    );
  }
}

