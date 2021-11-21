import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Widget child;
  final Color color;
  final double appWidth;
  final bool showBorder;
  final bool containsError;

  CustomTextField({
    required this.child,
    required this.icon,
    required this.iconSize,
    required this.color,
    this.showBorder = false,
    this.containsError = false,
    required this.appWidth,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          side: containsError
              ? BorderSide(width: 1, color: Colors.red.shade900)
              : showBorder
                  ? BorderSide(width: 1, color: Colors.black)
                  : BorderSide(width: 0, color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
        child: SizedBox(
          height: 75,
          width: double.maxFinite,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: VerticalDivider(
                    color: Colors.black26,
                    width: 10,
                  ),
                ),
                SizedBox(width: appWidth, child: child),
              ]),
        ),
      ),
    );
  }
}
