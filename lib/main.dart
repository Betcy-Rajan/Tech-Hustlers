import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nearsq/data/repositories/authentication/authentication_repository.dart';

import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Local Storage
  await GetStorage.init();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Get.put(AuthenticationRepository());
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  // await setUp();
  runApp(const MyApp());
}
// Future<void> setUp() async {
//   await dotenv.load(fileName: ".env");
//   MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);
// }