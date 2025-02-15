import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:iconsax/iconsax.dart';
import 'package:nearsq/features/Camp/screens/camp.dart';
import 'package:nearsq/features/Camp/screens/campofficial.dart';
import 'package:nearsq/features/personalization/screens/settings/settings.dart';
import 'package:nearsq/features/nearsq/screens/home/home.dart';
import 'package:nearsq/features/users/Volunteer/volunteer_map.dart';
// import 'package:nearsq/features/shop/screens/nearsq/nearsq.dart';
// import 'package:nearsq/features/shop/screens/whishlist/whishlist.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/helpers/helper_functions.dart';


class NavigationMenuOfficial extends StatelessWidget {
  const NavigationMenuOfficial({super.key});


  @override
  Widget build(BuildContext context) {
    
    final  controller = Get.put(NavigationMenuController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: controller.updateIndex,
        backgroundColor: darkMode ? Colors.black : Colors.white,
        indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
        destinations: const  [
           NavigationDestination(icon: Icon(Iconsax.home),label: 'Home',),
           NavigationDestination(icon: Icon(Iconsax.shop),label: 'Heatmap',),
           NavigationDestination(icon: Icon(Iconsax.heart),label: 'VolunteerMap',),
           NavigationDestination(icon: Icon(Iconsax.user),label: 'Home',),
        ]
      )),
      body: Obx(() => controller.screens[controller.selectedIndex.value])
    );
  }
}
class NavigationMenuController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final screens = [const MyHomePage(),CampScreenOfficial(),const VolunteerMap()];
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

}