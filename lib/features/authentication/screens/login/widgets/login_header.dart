import 'package:flutter/material.dart';
import 'package:nearsq/utilis/constants/image_strings.dart';
import 'package:nearsq/utilis/constants/sizes.dart';
import 'package:nearsq/utilis/constants/text_strings.dart';
import 'package:nearsq/utilis/helpers/helper_functions.dart';
class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
     final dark =THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(dark ? TImages.darkAppLogo : TImages.lightAppLogo ),width: THelperFunctions.screenWidth()*0.6,),
        Text(TTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: TSizes.sm,),
        Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
    );
  }
}