import 'package:flutter/material.dart';
import '../design_system.dart';

class FisheriIconButton extends StatefulWidget {
  FisheriIconButton({
    this.icon,
    this.onTap,
  });

  @required
  final Icon icon;
  @required
  final Function onTap;

  @override
  FisheriIconButtonState createState() => FisheriIconButtonState();
}

class FisheriIconButtonState extends State<FisheriIconButton> {
  Color _color = DSColors.black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (tapDetails) {
        widget.onTap();
        setState(() {
          _color = DSColors.black;
        });
      },
      onTapDown: (tapDetails) {
        setState(() {
          _color = DSColors.green;
        });
      },
      onTapCancel: () {
        setState(() {
          _color = DSColors.black;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: _color,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.36),
                  offset: Offset(4,8),
                  blurRadius: 16
              )
            ]
        ),
        child: widget.icon,
      ),
    );
  }
}