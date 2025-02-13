import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nearsq/data/repositories/authentication/authentication_repository.dart';

import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

Future<void> main() async {
  //Widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //Initialize Local Storage
  await GetStorage.init();
  //Await Splash until other  items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Intialize FireBase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository()),
    );
 
  runApp(const MyApp());

}
