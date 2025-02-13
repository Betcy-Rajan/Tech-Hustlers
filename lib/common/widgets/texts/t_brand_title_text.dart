import 'package:flutter/material.dart';
import 'package:nearsq/utilis/constants/enums.dart';



class TBrandTitleText extends StatelessWidget {
  const TBrandTitleText({
    super.key, 
    required this.title,
     required this.maxLines, 
     this.color, 
     this.textAlign,
      this.brandTextSizes = TextSizes.small});

  final String title;
  final int maxLines;
  final Color? color;
 
  final TextAlign? textAlign;
  final TextSizes brandTextSizes;

 
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: brandTextSizes == TextSizes.small 
      ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
      : brandTextSizes == TextSizes.medium
      ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
      : brandTextSizes == TextSizes.large
      ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
      : Theme.of(context).textTheme.bodyMedium!.apply(color: color),
      
    );
  }

  double _getFontSize() {
    switch (brandTextSizes) {
      case TextSizes.small:
        return 12.0;
      case TextSizes.medium:
        return 16.0;
      case TextSizes.large:
        return 20.0;
      default:
        return 16.0;
    }
  }
}