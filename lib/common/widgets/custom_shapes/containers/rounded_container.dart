import 'package:flutter/material.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/constants/sizes.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({super.key, 
  this.width, 
  this.height, 
  this.radius = TSizes.cardRadiusLg, 
  this.child, 
  this.showBorder = false, 
  this.borderColor = TColors.borderPrimary, 
   this.backgroundColor = TColors.white, 
  this.margin, 
  this.padding,
  
  });
  final double ? width;
  final double ? height;
  final double radius;
  final Widget ? child;
  final bool showBorder;
  final Color borderColor;
   final Color  backgroundColor;
    final EdgeInsetsGeometry ? margin;
    final EdgeInsetsGeometry ? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}