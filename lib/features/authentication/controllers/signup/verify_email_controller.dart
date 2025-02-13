import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nearsq/common/widgets/success_screen/success_screen.dart';

import 'package:nearsq/data/repositories/authentication/authentication_repository.dart';
import 'package:nearsq/utilis/constants/image_strings.dart';
import 'package:nearsq/utilis/constants/text_strings.dart';
import 'package:nearsq/utilis/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  // Add your variables and methods 
  static VerifyEmailController get instance => Get.find();
//send Email Whenever Verify Screen appears and set Timer for auto redirect

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
    
  }
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(title: 'Email Sent', message: 'We have sent you an email to verify your account');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
  setTimerForAutoRedirect()  {
    Timer.periodic(
      const Duration(seconds: 1),
    (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false ) {
        timer.cancel();
         Get.off(() => SuccessScreen(
          title: TTexts.yourAccountCreatedTitle,
           subtitle: TTexts.yourAccountCreatedSubTitle,
            image: TImages.successfullyRegistrationAnimation, 
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
            )
            );
      
       
      }   
    }
  
    );
  }
    checkEmailVerificationStatus() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.emailVerified ?? false) {
        Get.off(() => SuccessScreen(
          title: TTexts.yourAccountCreatedTitle,
          subtitle: TTexts.yourAccountCreatedSubTitle,
          image: TImages.successfullyRegistrationAnimation,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ));
        
      }
    }

  }

 
