import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget? child;
  final Gradient? gradient;
  final BoxDecoration? decorication;
  final double width;
  final double height;
  final double? borderRadius;
  final VoidCallback onPressed;

  const RaisedGradientButton({
    Key? key,
    required this.child,
    this.gradient,
    this.width = double.infinity,
    this.borderRadius,
    this.decorication,
    this.height = 50.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: decorication,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: child,
          ),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
      ),
    );
  }
}
