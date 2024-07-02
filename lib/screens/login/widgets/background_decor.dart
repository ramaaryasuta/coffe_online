import 'package:coffeonline/styles/colors.dart';
import 'package:flutter/material.dart';

class BackgroundDecor extends StatelessWidget {
  const BackgroundDecor({
    super.key,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [MyColor.primaryColor, MyColor.secondaryColor]),
          borderRadius: BorderRadius.circular(150),
        ),
      ),
    );
  }
}
