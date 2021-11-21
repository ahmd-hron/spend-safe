import 'package:flutter/material.dart';

import '../helper/theme_colors.dart';

class CircularContainer extends StatelessWidget {
  final Widget? child;
  final double? minHeightWidth;
  final double? maxHeightWidth;
  final Color circleColor;
  CircularContainer(
      {this.minHeightWidth,
      required this.circleColor,
      required this.child,
      this.maxHeightWidth});
  @override
  Widget build(BuildContext context) {
    return maxHeightWidth == null
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
              gradient: ThemeColors.myBlueGradient,
            ),
            constraints: BoxConstraints(
              minHeight: minHeightWidth == null ? 0 : minHeightWidth!,
              minWidth: minHeightWidth == null ? 0 : minHeightWidth!,
            ),
            alignment: Alignment.center,
            child: child,
          )
        : Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: circleColor),
            constraints: BoxConstraints(
              maxHeight: maxHeightWidth!,
              maxWidth: maxHeightWidth!,
            ),
            alignment: Alignment.center,
            child: child,
          );
  }
}
