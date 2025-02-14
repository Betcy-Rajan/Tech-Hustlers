import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:nearsq/bindings/general_bindings.dart';
import 'package:nearsq/features/nearsq/screens/home/home.dart';

import 'package:nearsq/navigation_drawer_widget.dart';

// import 'package:nearsq/features/authentication/screens/onboarding/onboarding.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/theme/theme.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase before loading the app
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Show loading spinner while initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        // Show error if initialization failed
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }

        // Once Firebase is initialized, show your app
        return GetMaterialApp(
          themeMode: ThemeMode.system,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          initialBinding: GeneralBindings(),
          home: const MyHomePage(), // Replace CircularProgressIndicator with your actual home page
        );
      },
    );
  }
}
