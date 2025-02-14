import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearsq/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:nearsq/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:nearsq/features/authentication/screens/onboarding/widgets/onboarding_next.dart';
import 'package:nearsq/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:nearsq/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';

import 'package:nearsq/utilis/constants/image_strings.dart';
import 'package:nearsq/utilis/constants/text_strings.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return  Scaffold(
      body: Stack(
        children: [

          //Horizontal  Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              
              //  OnBoardingPage(image: TImages.onBoardingImage1,title: TTexts.onBoardingTitle1,subTitle: TTexts.onBoardingSubTitle1,),
              //  OnBoardingPage(image: TImages.onBoardingImage2,title: TTexts.onBoardingTitle2,subTitle: TTexts.onBoardingSubTitle2,),
              // OnBoardingPage(image: TImages.onBoardingImage3,title: TTexts.onBoardingTitle3,subTitle: TTexts.onBoardingSubTitle3,),

              OnBoardingPage(title: TTexts.onBoardingTitle1,subTitle: TTexts.onBoardingSubTitle1,),
               OnBoardingPage(title: TTexts.onBoardingTitle2,subTitle: TTexts.onBoardingSubTitle2,),
              OnBoardingPage(title: TTexts.onBoardingTitle3,subTitle: TTexts.onBoardingSubTitle3,),
            ],
          ),
        
          //Skip Button
          const OnBoardingSkip(),

          ///Dot Navigation smoothPage Indicator
          const OnBoardingDotNavigation(),

          //Circular Button
          const OnBoardingNextButton(),
        ],
      )
    );
  }
}





