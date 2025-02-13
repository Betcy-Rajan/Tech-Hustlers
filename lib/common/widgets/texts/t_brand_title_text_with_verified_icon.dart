
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/common/widgets/texts/t_brand_title_text.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/constants/enums.dart';
import 'package:nearsq/utilis/constants/sizes.dart';

class TBrandTitleWithVerifiedIcon extends StatelessWidget {
  const TBrandTitleWithVerifiedIcon({
    super.key, required this.title,  this.maxLines = 1, this.textColor, this.iconColor = TColors.primaryColor, this.textAlign = TextAlign.center, this.brandTextSizes = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color ? textColor,iconColor;
  final TextAlign ? textAlign;
  final TextSizes brandTextSizes;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: 
        TBrandTitleText(title: title, 
        maxLines: maxLines,
        textAlign: textAlign,
        brandTextSizes: brandTextSizes,
        color: textColor,
        
        ),
        ),
        
        const SizedBox(width: TSizes.xs),
        const Icon(
          Iconsax.verify5,
          color: TColors.primaryColor,
          size: TSizes.iconXs,
        ),
      ],
    );
  }
}