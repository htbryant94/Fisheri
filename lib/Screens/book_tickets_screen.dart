import 'package:flutter/material.dart';

class BookTicketsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Image.asset('images/placeholders/book_tickets.png', fit: BoxFit.fitWidth)
          )
      ),
    );
  }
}