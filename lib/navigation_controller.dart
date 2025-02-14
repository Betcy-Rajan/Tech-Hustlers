import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Reactive variable for collapsed state
  var isCollapsed = false.obs;

  // Method to toggle the collapsed state
  void toggleIsCollapsed() {
    isCollapsed.value = !isCollapsed.value;
  }
}