import 'package:flutter/material.dart';

import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/constants/sizes.dart';
import 'package:nearsq/utilis/helpers/helper_functions.dart';

class TCircularIcon extends StatelessWidget {
  const TCircularIcon({
    super.key, this.size = TSizes.lg, this.width, this.height, this.color, this.icon, this.backgroundColor, this.onPressed, 
    
  });

  final double ? size,width,height;
  final Color ? color;
  final IconData ? icon;
  final Color ? backgroundColor;
  final VoidCallback ? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor!=null ? backgroundColor! : THelperFunctions.isDarkMode(context) ? TColors.black.withOpacity(0.9) : TColors.white.withOpacity(0.9),
      ),
      child: IconButton(onPressed: onPressed, icon:  Icon(icon, color: color,size: size,)),
    );
  }
}