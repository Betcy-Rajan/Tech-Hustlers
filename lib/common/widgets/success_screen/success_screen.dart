import 'package:flutter/material.dart';
import 'package:nearsq/common/styles/spacing_styles.dart';
import 'package:nearsq/utilis/constants/sizes.dart';
import 'package:nearsq/utilis/constants/text_strings.dart';
import 'package:nearsq/utilis/helpers/helper_functions.dart';



class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.title, required this.subtitle, required this.image, required this.onPressed});
  final String title,subtitle,image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
             ///image
              Image(image:  AssetImage(image),width: THelperFunctions.screenWidth()*0.6,),
              const SizedBox(height: TSizes.spaceBtwSections,),

              ///title and subtitle
               
              Text(title, style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwItems,),
              Text(subtitle, style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center,),
              const SizedBox(height: TSizes.spaceBtwSections,),
              ///button
               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(TTexts.tContinue),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}