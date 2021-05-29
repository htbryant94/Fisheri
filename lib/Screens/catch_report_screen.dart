import 'package:fisheri/Screens/catch_form_screen_full.dart';
import 'package:fisheri/Screens/detail_screen/description_section.dart';
import 'package:fisheri/Screens/detail_screen/image_carousel.dart';
import 'package:fisheri/WeightConverter.dart';
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

  final CatchReport catchReport;
  final String catchReportID;

  @override
  _CatchReportScreenState createState() => _CatchReportScreenState();
}

class _CatchReportScreenState extends State<CatchReportScreen> {
  final int _initialPageValue = 0;
  int _segmentedControlSelectedValue;
  PageController _pageController;
  Future<List<Catch>> _catches;

  @override
  void initState() {
    _catches = FirestoreRequestService.defaultService().getCatches(catchReportID: widget.catchReportID);
    _pageController = PageController(initialPage: _initialPageValue);
    _segmentedControlSelectedValue = _initialPageValue;
    super.initState();
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
                      FutureBuilder<List<Catch>>(
                        future: _catches,
                        builder: (BuildContext context, AsyncSnapshot<List<Catch>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.isEmpty) {
                              return DSComponents.titleLarge(
                                  text: 'No Catches  🎣',
                                  alignment: Alignment.center
                              );
                            }
                            return _CatchListBuilder(catches: snapshot.data);
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            DSComponents.doubleSpacer(),
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
                              )
                          ],
                        ),
                      )

                    ],

                  ),
                  Positioned(
                    bottom: 12,
                    left: 24,
                    right: 24,
                    child: _NewCatchButton(onPressed: () {
                      _pushNewCatchForm(
                        context: context,
                        onDismiss: () {
                          setState(() {
                            _catches = FirestoreRequestService.defaultService().getCatches(catchReportID: widget.catchReportID);
                          });
                        }
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

  void _pushNewCatchForm({BuildContext context, VoidCallback onDismiss}) {
    final startDate = DateTime.parse(widget.catchReport.startDate);
    final endDate = DateTime.parse(widget.catchReport.endDate);

    var dateRange = List.generate(
        endDate.difference(startDate).inDays + 1,
        (day) =>
            DateTime(startDate.year, startDate.month, startDate.day + day));
    Coordinator.present(context,
        currentPageTitle: 'Catches',
        screen: CatchFormScreenFull(
          dateRange: dateRange,
          catchReportID: widget.catchReportID,
          onDismiss: onDismiss
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

class _CatchListBuilder extends StatelessWidget {
  _CatchListBuilder({@required this.catches});

  final List<Catch> catches;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: catches.length,
        padding: EdgeInsets.fromLTRB(8, 24, 8, 68),
        separatorBuilder: (BuildContext context, int index) {
          return DSComponents.singleSpacer();
        },
        itemBuilder: (context, index) {
          final _catch = catches[index];
          return CatchCell(
            catchData: _catch,
          );
        });
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
