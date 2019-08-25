import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(this.header);

  final String header;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(header,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )));
  }
}
