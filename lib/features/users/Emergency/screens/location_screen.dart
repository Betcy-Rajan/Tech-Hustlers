// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:nearsq/features/users/Emergency/controllers/location_controller.dart';
// import 'package:nearsq/features/personalization/models/user_models.dart';

// class LocationScreen2 extends StatelessWidget {
//   LocationScreen2({Key? key}) : super(key: key);

//   Future<UserModel> getCurrentUser() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw 'No user logged in';

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();
    
//     return UserModel.fromSnapshot(doc);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<UserModel>(
//       future: getCurrentUser(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }

//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(
//               child: Text('Error: ${snapshot.error}'),
//             ),
//           );
//         }

//         final currentUser = snapshot.data!;
//         final LocationController locationController = Get.put(
//           LocationController(currentUser: currentUser)
//         );

//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Emergency SOS'),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Send emergency SOS with your current location'),
//                 SizedBox(height: 20),
//                 Obx(() => locationController.isLoading.value
//                     ? CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: () async {
//                           await locationController.getCurrentLocation();
//                           await locationController.sendSOS();
//                         },
//                         child: Text('Send SOS'),
//                       )),
//                 SizedBox(height: 20),
//                 Obx(() => Text(
//                       'Location: ${locationController.latitude.value}, ${locationController.longitude.value}',
//                     )),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearsq/features/users/Emergency/controllers/location_controller.dart';
import 'package:nearsq/features/personalization/models/user_models.dart';

class LocationScreen2 extends StatelessWidget {
  LocationScreen2({Key? key}) : super(key: key);

  Future<UserModel> getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'No user logged in';

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    return UserModel.fromSnapshot(doc);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final currentUser = snapshot.data!;
        final LocationController locationController = Get.put(
          LocationController(currentUser: currentUser)
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Emergency SOS'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Send emergency SOS with your current location'),
                SizedBox(height: 20),
                Obx(() => locationController.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          await locationController.getCurrentLocation();
                          await locationController.sendSOS();
                        },
                        child: Text('Send SOS'),
                      )),
                SizedBox(height: 20),
                Obx(() => Text(
                      'Location: ${locationController.latitude.value}, ${locationController.longitude.value}',
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}