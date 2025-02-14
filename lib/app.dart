
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:nearsq/bindings/general_bindings.dart';

import 'package:nearsq/navigation_drawer_widget.dart';

// import 'package:nearsq/features/authentication/screens/onboarding/onboarding.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: Scaffold(
        drawer: NavigationDrawerWidget(),
        backgroundColor: TColors.primaryBackground,
        
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    
      
    );
  }
}
