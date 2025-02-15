import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:nearsq/features/personalization/models/user_models.dart';
// import 'package:nearsq/features/users/Emergency/screens/location_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/features/users/Emergency/screens/locationscreen.dart';

import 'package:nearsq/features/Camp/screens/camp.dart';
import 'package:nearsq/features/personalization/screens/settings/settings.dart';
import 'package:nearsq/features/users/Logout/logout_screen.dart';
import 'package:nearsq/features/users/Volunteer/screen/volunteer_registration.dart';
import 'package:nearsq/features/users/chatboat/chatbot.dart';
// import 'package:nearsq/features/nearsq/screens/home/home.dart';
// import 'package:nearsq/features/shop/screens/nearsq/nearsq.dart';
// import 'package:nearsq/features/shop/screens/whishlist/whishlist.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/helpers/helper_functions.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});


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
           NavigationDestination(icon: Icon(Iconsax.shop),label: 'Emergency',),
           NavigationDestination(icon: Icon(Iconsax.heart),label: 'Volunteer',),
           NavigationDestination(icon: Icon(Iconsax.user),label: 'Logout',),
           NavigationDestination(icon: Icon(Iconsax.user),label: 'ChatBot',),

        ]
      )),
      body: Obx(() => controller.screens[controller.selectedIndex.value])
    );
  }
}
class NavigationMenuController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final screens = [LocationScreen(),CampScreen(),const VolunteerRegistrationForm(), LogoutScreen(),const ChatPage()];
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

}