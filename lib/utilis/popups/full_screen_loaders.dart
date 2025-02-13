import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearsq/common/loaders/animation_loader.dart';
import 'package:nearsq/utilis/helpers/helper_functions.dart';

class TFullScreenLoader {
  static void openLoadingDialog( String text, String animation) {
    showDialog(
      context: Get.overlayContext!, //
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!) ? Colors.black : Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 100),
              TAnimationLoaderWidget(animation: animation,text:text),

            ],
          ),
        ))
        );
    
  
  }
  //stop the currently open loading dialog
  //this method does not return anything
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}