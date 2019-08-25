import 'package:flutter/material.dart';

class ButtonSection extends StatelessWidget {
  ButtonSection(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    Column _buildButtonColumn(Color color, IconData icon, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'Call'),
          _buildButtonColumn(color, Icons.language, 'Website'),
          _buildButtonColumn(color, Icons.email, 'Email'),
        ],
      ),
    );
  }
}
