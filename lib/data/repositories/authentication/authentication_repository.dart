// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:nearsq/features/authentication/screens/login/login.dart';
// import 'package:nearsq/features/authentication/screens/onboarding/onboarding.dart';

// import 'package:nearsq/features/authentication/screens/signup/verify_email.dart';
// import 'package:nearsq/navigation_menu.dart';
// import 'package:nearsq/utilis/exceptions/firebase_auth_exceptions.dart';
// import 'package:nearsq/utilis/exceptions/firebase_exceptions.dart';
// import 'package:nearsq/utilis/exceptions/format_exceptions.dart';
// import 'package:nearsq/utilis/exceptions/platform_exceptions.dart';

// class AuthenticationRepository extends GetxController {
//   static AuthenticationRepository get instance => Get.find();

//   //Variables
//   final deviceStorage = GetStorage();
//   final _auth = FirebaseAuth.instance;

//   //Called from main.dart on app launch
//   @override
//   void onReady() {
//     FlutterNativeSplash.remove();
//     screenRedirect();
//   }
//    screenRedirect() async {

//     User? user = _auth.currentUser;
//     if(user != null) {
//       if(user.emailVerified) {

//         Get.offAll(() => const NavigationMenu());
//       } else {
//         Get.offAll(() => VerifyEmailScreen(email: user.email));
//       }
//     } else {
//         //Local Storage
//         deviceStorage.writeIfNull('isFirstTime', true);
//         deviceStorage.read('isFirstTime') != true ? Get.offAll(()=> const LoginScreen()): Get.offAll(() => const OnBoardingScreen());
     
//     }
  

//   }

//   ///Email Authentication - Sign In
//   Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       return await _auth.signInWithEmailAndPassword(email: email, password: password);
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException catch (_) {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (e) {
//       throw 'Something went wrong.Please try again';
//     }
//   }
  
//   ///Email Authentication - Register
//   Future<UserCredential> registerWithEmailAndPassword(String email, String password,String role) async {
//     try {
//       return await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
//     } on FirebaseAuthException catch (e) {
//        throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException catch (_) {
//        throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message; 
//     } catch (e) {
//       throw 'Something went wrong.Please try again';
//     }
   
//   }
  
//   ///ReAuthenticate - Reauthenticate User
//   ///EmailVerification -  Email Verification
//   Future<void> sendEmailVerification() async {
//     try {
//       await _auth.currentUser?.sendEmailVerification();
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException catch (_) {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (e) {
//       throw 'Something went wrong.Please try again';
//     }
//   }
//   ///EmailAuthentication - Forgot Password
//     Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email:email);
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException catch (_) {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (e) {
//       throw 'Something went wrong.Please try again';
//     }
//   }
  

//   ///Google Authentication - Google
//   ///Facebook Authentication - Facebook
  
//   ///LogoutUser - Logout User
//   Future<void> logout() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Get.offAll(() => const LoginScreen());
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException catch (_) {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (e) {
//       throw 'Something went wrong.Please try again';
//     }
//   }
//   ///DeleteUser - Delete User
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nearsq/features/authentication/screens/login/login.dart';
import 'package:nearsq/features/authentication/screens/onboarding/onboarding.dart';
import 'package:nearsq/navigation_menu.dart';
import 'package:nearsq/navigation_official.dart';


import 'package:nearsq/utilis/exceptions/firebase_auth_exceptions.dart';
import 'package:nearsq/utilis/exceptions/firebase_exceptions.dart';
import 'package:nearsq/utilis/exceptions/format_exceptions.dart';
import 'package:nearsq/utilis/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }
   screenRedirect() async {

    User? user = _auth.currentUser;
    if (user != null) {
    // Fetch user data from Firestore
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if(userDoc.exists) {
      String username = userDoc.get('Username');
      if(username=="official") {
        Get.offAll(() => const NavigationMenuOfficial());
      } else {
        Get.offAll(() =>  NavigationMenu());
      }
    }
  }

     
     else {
        //Local Storage
        deviceStorage.writeIfNull('isFirstTime', true);
        deviceStorage.read('isFirstTime') != true ? Get.offAll(()=> const LoginScreen()): Get.offAll(() => const OnBoardingScreen());
    }
  

  }

  ///Email Authentication - Sign In
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.Please try again';
    }
  }
  
  ///Email Authentication - Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password,String role) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Add user details to Firestore 
    } on FirebaseAuthException catch (e) {
       throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
       throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message; 
    } catch (e) {
      throw 'Something went wrong.Please try again';
    }
   
  }
  
  ///ReAuthenticate - Reauthenticate User
  ///EmailVerification -  Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.Please try again';
    }
  }
  ///EmailAuthentication - Forgot Password
    Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email:email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.Please try again';
    }
  }
  

  ///Google Authentication - Google
  ///Facebook Authentication - Facebook
  
  ///LogoutUser - Logout User
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.Please try again';
    }
  }
  ///DeleteUser - Delete User
}

