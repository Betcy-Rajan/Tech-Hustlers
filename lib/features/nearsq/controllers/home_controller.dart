import 'package:get/get.dart';

class HomeController extends GetxController {
  // Define your variables and methods here
  static HomeController get instance => Get.find();
  final carouselCurrentIndex = 0.obs;
  void updatePageIndicator(int index) {
    carouselCurrentIndex.value = index;
    
  }
}