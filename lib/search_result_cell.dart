import 'package:flutter/material.dart';

class _Title extends StatelessWidget {
  _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        '$title',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class SearchResultCell extends StatelessWidget {
  SearchResultCell({
    Key key,
    this.title,
    this.venueType,
    this.distance,
    this.isOpen,
    this.readDuration,
  }) : super(key: key);

  final String title;
  final String venueType;
  final String distance;
  final bool isOpen;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // const Padding(padding: EdgeInsets.only(top: 8.0)),
              _Title(title),
              // Text(
              //   '$title',
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   style:
              //       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              // ),
              // const Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Text(
                '$venueType',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Text(
                '${isOpen ? "Open" : "Closed"}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isOpen ? Colors.green : Colors.red,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.directions_boat),
                  Icon(Icons.directions_bike),
                  Icon(Icons.directions_car),
                  Text(
                    '$distance',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Expanded(
        //   flex: 1,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[

        //     ],
        //   ),
        // ),
        // Expanded(
        //   flex: 1,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[
        //       Text(
        //         '$author',
        //         style: const TextStyle(
        //           fontSize: 12,
        //           color: Colors.black87,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Expanded(
        //   flex: 1,
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[
        //       Icon(Icons.directions_boat),
        //       Icon(Icons.directions_bike),
        //       Icon(Icons.directions_car),
        //       Text(
        //         '$author',
        //         style: const TextStyle(
        //           fontSize: 12,
        //           color: Colors.black87,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
