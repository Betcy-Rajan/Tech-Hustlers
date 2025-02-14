// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:nearsq/features/personalization/models/user_models.dart';

// class LocationController extends GetxController {
//   var latitude = 0.0.obs;
//   var longitude = 0.0.obs;
//   var isLoading = false.obs;
  
//   // Reference to get current user data
//   final UserModel currentUser ;

//   LocationController({required this.currentUser});

//   Future<void> getCurrentLocation() async {
//     isLoading.value = true;
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       latitude.value = position.latitude;
//       longitude.value = position.longitude;
//     } catch (e) {
//       Get.snackbar('Error', 'Unable to get location: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> sendSOS() async {
//     if (latitude.value == 0.0 || longitude.value == 0.0) {
//       Get.snackbar('Error', 'Location not available');
//       return;
//     }

//     try {
//       // Create new SOS entry
//       Map<String, dynamic> newSosEntry = {
//         'lat': latitude.value,
//         'lon': longitude.value,
//         'msg': 'Emergency SOS',
//         'name': currentUser.fullName,
//         'phone': currentUser.phoneNumber,
//         'timestamp': DateTime.now().toString(),
//       };

//       // Get reference to the 'online' document
//       final DocumentReference docRef = FirebaseFirestore.instance
//           .collection('sos')
//           .doc('online');

//       // Use transaction to safely update the array
//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(docRef);

//         if (!snapshot.exists) {
//           // If document doesn't exist, create it with initial array
//           transaction.set(docRef, {
//             'sos': [newSosEntry]
//           });
//         } else {
//           // Get existing sos array
//           List<dynamic> existingSos = (snapshot.data() as Map<String, dynamic>)['sos'] ?? [];
          
//           // Add new entry to the array
//           existingSos.add(newSosEntry);

//           // Update document with merged array
//           transaction.update(docRef, {
//             'sos': existingSos
//           });
//         }
//       });
          
//       Get.snackbar('Success', 'SOS signal sent successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send SOS: $e');
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearsq/features/personalization/models/user_models.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading = false.obs;
  
  // Reference to get current user data
  final UserModel currentUser ;

  LocationController({required this.currentUser});

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      Get.snackbar('Error', 'Unable to get location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendSOS() async {
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar('Error', 'Location not available');
      return;
    }

    try {
      // Create new SOS entry
      Map<String, dynamic> newSosEntry = {
        'lat': latitude.value,
        'lon': longitude.value,
        'msg': 'Emergency SOS',
        'name': currentUser.fullName,
        'phone': currentUser.phoneNumber,
        'timestamp': DateTime.now().toString(),
      };

      // Get reference to the 'online' document
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('sos')
          .doc('online');

      // Use transaction to safely update the array
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          // If document doesn't exist, create it with initial array
          transaction.set(docRef, {
            'sos': [newSosEntry]
          });
        } else {
          // Get existing sos array
          List<dynamic> existingSos = (snapshot.data() as Map<String, dynamic>)['sos'] ?? [];
          
          // Add new entry to the array
          existingSos.add(newSosEntry);

          // Update document with merged array
          transaction.update(docRef, {
            'sos': existingSos
          });
        }
      });
          
      Get.snackbar('Success', 'SOS signal sent successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to send SOS: $e');
    }
  }
}